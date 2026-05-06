#=======================LIMPEZA DO ABLIENTE=====================================
#limpa objetos do workspace e previne conflitos
rm(list = ls())

#Evita notação cientifica e melhora a legibilidade numérica no console
options(scipen = 999, digits = 4)

#Fecha janelas graficas abertas em execuções anteriores
graphics.off()

#=========================================================================
# 2.2 Coleta de Dados
#=========================================================================

# a) Cosntrução do Dataframe
#----------------------------

  #recebe o link de download da tabela
  url_csv <- "https://drive.google.com/uc?export=download&id=12_MRBwS1QP26HpwuVAJr4cb-gylc0m5d"
  
  #recebe a leitura do arquivo
  criminalidade_sp <- readr::read_csv(url_csv)
  
  # Seleção do Estado
  estado <- "SP" 
  
  df_base <- criminalidade_sp %>%
    filter(uf == estado) %>%
  # Garantir que o código seja tratado como texto para evitar perda de zeros à esquerda
    mutate(cod_municipio = as.character(cod_municipio))
  
  # Verificar se o filtro funcionou
  print(paste("Total de Municípios no estado selecionado:", nrow(df_base)))
  
#b)Ulilizar o pacote SIDRAR
#---------------------------

#=========================================================================
# 2.3 Construção do Modelo
#=========================================================================

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



