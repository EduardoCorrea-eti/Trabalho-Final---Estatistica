#=======================LIMPEZA DO ABLIENTE=====================================
#limpa objetos do workspace e previne conflitos
rm(list = ls())

#Evita notação cientifica e melhora a legibilidade numérica no console
options(scipen = 999, digits = 4)

#Fecha janelas graficas abertas em execuções anteriores
graphics.off()

#=======================PACOTES NECESSÁRIOS=====================================
#instalação caso necessário
if(!require("sidrar")) install.packages("sidrar")
if(!require("conflicted")) install.packages("conflicted")
if(!require("readr")) install.packages("readr")
if(!require("ipeadatar")) install.packages("ipeadatar")
if(!require("tidyr")) install.packages("tidyr")


#chamando bibliotecas
library(readr)
library(dplyr)
library(sidrar)
library(tidyverse)
library(conflicted)
library(janitor)
library(ipeadatar)
library(tidyr)
library(ipeadatar)

#===================ESTABELECENDO AS PASTAS DE TRABALHO=========================
# Exibe o diretório raiz do projeto, caso esteja usando projeto RStudio
here::here()

#Estabelecendo as pastas de trabalho
wd <-"~/Documentos/IFSM/ModuloII/Introducao_a_Estatistica_e_Probabilidade/Trabalho-Final---Estatistica"
wd1 <- file.path(wd, "arquivos_gerados/")

# Define a pasta de trabalho ativa
setwd(wd1)

# Lista arquivos da pasta para conferência
list.files()

#=========================================================================
# 2.2 Coleta de Dados
#=========================================================================
# a) Cosntrução do Dataframe - Dados de Criminalidade
#VARIÁVEL: df_dados_de_criminalidade
#----------------------------

#recebe o link de download da tabela
url_csv <- "https://drive.google.com/uc?export=download&id=12_MRBwS1QP26HpwuVAJr4cb-gylc0m5d"

#recebe a leitura do arquivo
dados_de_criminalidade <- readr::read_delim(url_csv, 
                                            delim = ",",
                                            col_names = TRUE, 
                                            locale = locale(encoding = "UTF-8", decimal_mark = "."),
                                            col_types = cols(uf             = col_character(),
                                                             municipio      = col_character(),
                                                             cod_municipio  = col_integer(),
                                                             total_vitima   = col_integer(),
                                                             populacao_2022 = col_integer())
                                            ) %>%
  #arredondamento de casas decimais
  mutate(taxa_100mil = round(taxa_100mil, 2))


# Seleção do Estado
estado <- "SP" 

df_dados_de_criminalidade <- dados_de_criminalidade %>%
dplyr::filter(uf == estado) %>%
# Garantir que o código seja tratado como texto para evitar perda de zeros à esquerda
mutate(cod_municipio = as.character(cod_municipio))

# Verificar se o filtro funcionou
print(paste("Total de Municípios no estado selecionado:", nrow(df_dados_de_criminalidade)))
head(df_dados_de_criminalidade)

write_csv(df_dados_de_criminalidade, "dados_de_criminalidade.csv") 
list.files() #Lista arquivos na pasta para conferência
 
#--------------------------- 
#b)Ulilizar o pacote SIDRAR - Dados do Produto Interno Bruto de 2023 para cada município
#VARIÁVEL: df_pib_per_capita
#---------------------------
#recupera os dados dos municipios de SP no SIDRAR
pib_tot_2023 <- get_sidra(api = "/t/5938/n6/all/v/37/p/last%201/d/v37%200")

pib_tot_2023

pib_tot_2023 <- pib_tot_2023 %>% 
  clean_names() %>%
  select(cod_municipio = "municipio_codigo","municipio", "valor") %>%
  dplyr::filter(str_ends(municipio," - SP"))

pib_tot_2023

df_dados_de_criminalidade_limpo <- df_dados_de_criminalidade %>% clean_names()
names(df_dados_de_criminalidade_limpo)
names(pib_tot_2023)

pib_tot_2023

#integrando as tabelas
df_pib_per_capita <- pib_tot_2023 %>%
  left_join(df_dados_de_criminalidade_limpo, by = c("cod_municipio" = "cod_municipio")) %>%
  select(municipio = "municipio.y", pib_total_mil = "valor", "populacao_2022") %>%
  mutate( pib_per_capita = (pib_total_mil * 1000) / populacao_2022, pib_per_capita = round(pib_per_capita, 2))#calculo considerando o valor em mil reais (valor * 1000)


#DEBUG
head(df_pib_per_capita)

#Gravando arquivo na pasta
write_csv(df_pib_per_capita, "Pib_per_capita.csv")

  
#---------------------------  
#c) Quantidade de aglomerados urbanos por municipio
#VARIÁVEL: df_aglomerados_por_municipio
#---------------------------
#RECEBE O RETORNO DA API
url_aglomerados <- get_sidra(api = "/t/9883/n6/all/v/all/p/all")
#IDENTIFICA DO TIPO DA VARIAVEL
class(url_aglomerados)

#SANITIZAÇÃO DE NOMES DE COLUNAS
df_aglomerados_limpo <- url_aglomerados %>% clean_names()

#DEBUG
head(df_aglomerados_limpo)

#FORMATAÇÃO E SELEÇÃO DO DF 
df_aglomerados <- df_aglomerados_limpo %>%
  #SELEÇÃO DAS COLUNAS DE INTERESSE ALTERANDO NOME DE COLUNA,
  select(codigo ="municipio_codigo","municipio", "valor") %>%
  #FILTRO DE DADOS(*-SP), 
  dplyr::filter(str_ends(municipio, " - SP")) 

#DEBUG
# head(df_aglomerados)
# list.files() 

#CRIANDO DF_FINAL COM TODOS OS MUNICIPIOS E VALOR "0" ATRIBUIDO AO MUNICIPIO EM QUE NÃO HA AGLOMERADO
df_aglomerados_por_municipio <- df_dados_de_criminalidade %>%
  left_join(df_aglomerados, by = c("cod_municipio" = "codigo"))%>%
  select("cod_municipio",municipio = "municipio.x","uf",qnt_aglomerados = "valor") %>%
  #ALTERA OS RESULTADOS NA -> 0
  replace_na(list(qnt_aglomerados = 0))
  #ALTERNATIVA: DEVOLVE O MESMO RESULTADO
  # mutate(qnt_aglomerados = coalesce(as.numeric(qnt_aglomerados), 0))

#DEBUG
# head(df_aglomerados_por_municipio)
# print(df_aglomerados_por_municipio, n=600)

#GRAVA CSV NA PASTA
write_csv(df_aglomerados_por_municipio, "aglorerados_por_municipio.csv")

#---------------------------  
#d) Pessoas alfabetizadas por municipio, criar coluna com taxa de analfabetismo municipal
#VARIÁVEL: df_analfabetismo_por_municipio
#---------------------------
#RECEBE A URL
url_analfabetismo <- get_sidra(api = "/t/9543/n6/all/v/all/p/all/c2/6794/c86/95251/c287/100362/d/v2513%202")
#TRATAMENTO E SELEÇÃO DA TABELA
df_analfabetismo_por_municipio <-url_analfabetismo %>% 
  clean_names() %>%
  select(cod_municipio = "municipio_codigo", "municipio","valor", medida = "unidade_de_medida") %>%
  dplyr::filter(str_ends(municipio, " - SP")) %>%
  #CALCULO DO ANALFATETISMO POR MUNICIPIO
  mutate(valor = (100 - valor), valor = round(valor, 2)) 

#DEBUG
#print(analfabetismo)

#GRAVANDO CSV NA PASTA
write.csv(df_analfabetismo_por_municipio, "analfabetismo_por_municipio.csv")

#---------------------------  
#e)Percentual da população jovem (entre 15 e 29 anos)nos municípios
#VARIÁVEL: df_populacao_jovem_por_municipio
#---------------------------
#RECEBENDO DADOS DA API
populacao_jovem <- get_sidra(api = "/t/9514/n6/all/v/allxp/p/all/c2/6794/c287/93086,93087,93088/c286/113635")

#TRATANDO TABELA
df_populacao_15_29 <- populacao_jovem %>%
  clean_names() %>%
  select(cod_municipio = "municipio_codigo","municipio", "idade", "valor" ) %>%
  dplyr::filter(str_ends(municipio, " - SP")) %>%
  group_by(cod_municipio, municipio) %>%
  summarise(pop_jovem = sum(valor, na.rm = TRUE), .groups = "drop")
  
#DEBUG
# df_populacao_15_29
names(df_populacao_15_29)
names(df_dados_de_criminalidade)

#UNINDO TABELAS/CALCULANDO VALORES PARA CRIAÇÃO DA COLUNA POLULAÇÃO JOVEM POR MUNICIPIO
df_populacao_jovem_por_municipio <- df_populacao_15_29 %>%
  left_join(df_dados_de_criminalidade, by =c("cod_municipio" = "cod_municipio")) %>%
    mutate( pop_jovem_municipio = (pop_jovem * 100) / populacao_2022, medida = "%", pop_jovem_municipio = round(pop_jovem_municipio, 2)) %>%
    select("cod_municipio", municipio = "municipio.y", "pop_jovem_municipio", "medida")
  
  
df_populacao_jovem_por_municipio

write_csv(df_populacao_jovem_por_municipio, "populacao_jovem_por_municipio.csv")

#---------------------------  
#f)Familiasa beneficiadas pelo Bolsa Familia em dezembro de 2024
#VARIÁVEL: bolsa_familia_2024
#---------------------------
#=========================================================================
# f) Famílias beneficiárias do Bolsa Família (dez/2024)
# VARIÁVEL: df_pbf_por_municipio
#=========================================================================
# 1. Baixa a série completa do Bolsa Família
pbf_bruto <- ipeadata("FAM_PBF")

# print(pbf_bruto, n = 90698)
names(pbf_bruto)
# 2. Filtra para a data desejada e apenas municípios de SP
df_pbf_sp <- pbf_bruto %>%
  # Garante que o código seja tratado como texto
  mutate(code = as.character(code)) %>%
  
  # FILTRO DE SP: Mantém apenas códigos que começam com "35"
  # E filtra a data de dezembro de 2024 (jan/2025 no sistema)
  dplyr::filter(
    str_starts(tcode, "35"),
    date == as.Date("2025-01-01")
  ) %>%
  
  # Limpeza final
  rename(cod_municipio = code, total_familias_pbf = value, codigo_territorio = tcode) %>%
  select(cod_municipio, date, total_familias_pbf, codigo_territorio) %>%
  mutate(codigo_territorio = as.character(codigo_territorio))

# names(df_pbf_sp)
# print(df_pbf_sp)

names(df_dados_de_criminalidade_limpo)
names(df_pbf_sp)

df_pbf_por_municipio <- df_dados_de_criminalidade_limpo %>%
  left_join(df_pbf_sp, by = c("cod_municipio" = "codigo_territorio")) %>%
  mutate(
    pbf_100_mil = (total_familias_pbf / populacao_2022) * 100000,
    pbf_100_mil = round(pbf_100_mil, 2)) %>%
  select("cod_municipio", "municipio", "date", "total_familias_pbf", pbf_100_mil = "pbf_100_mil")

df_pbf_por_municipio

write_csv(df_pbf_por_municipio, "pbf_por_municipio.csv")

#RESUMO DA COLETA DE DADOS
print("Data Frame - Coleta de Datos - a)")
head(df_dados_de_criminalidade)
#------------------------------------------
print("Data Frame - Coleta de Datos - b)")
head(df_pib_per_capita)
#------------------------------------------
print("Data Frame - Coleta de Datos - c)")
head(df_aglomerados_por_municipio)
#------------------------------------------
print("Data Frame - Coleta de Datos - d)")
head(df_analfabetismo_por_municipio)
#------------------------------------------
print("Data Frame - Coleta de Datos - e)")
head(df_populacao_jovem_por_municipio)
#------------------------------------------
print("Data Frame - Coleta de Datos - f)")
head(df_pbf_por_municipio)
#------------------------------------------

#=========================================================================
# 2.3 Construção do Modelo
#=========================================================================
#a)Insira todas as variáveis em um novo data frame   

#b)

#c)

#d)

#e)
#=========================================================================
# 2.4 Análise do Modelo
#=========================================================================

#=========================================================================
# 2.5 Ajuste do Modelo
#=========================================================================

#=========================================================================
# 2.6 Simplificando o Modelo
#=========================================================================

#=========================================================================
# 2.7 Customizando o Modelo
#=========================================================================



