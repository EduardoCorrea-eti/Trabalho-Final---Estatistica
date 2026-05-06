****** CONFIGURAÇÃO DE AMBIENTE ******
Para garantir que o script rode normalmente em todos os sistemas.
Este projeto utiliza **renv** . Ao clonar o projeto, você deve executar o comando: renf::restore(), no console do Rstudio dentro da pasta do projeto
desta forma todas as bibliotecas estarão na versão compatível.



# Especialização em Ciência de Dados e Big Data 

**TRABALHO FINAL: ESTATÍSTICA - 2026**

Avaliação final em grupo

Análise da Associação entre Variáveis socioeconômicas dentre os municípios de uma unidade da federação 

Este trabalho é requisito para a disciplina de Estatística e Probabilidade 2026

### 1. Introdução

A análise de dados e a identificaçã  o de correlações entre variáveis podem fornecer insights valiosos para a formulação de políticas públicas e estratégias de atuação.

- Objetivo:
  - Realizar uma análise estatística descritiva e inferencial através de regressão linear múltipla.
  - Identificar possíveis relações entre indicadores e fatores sociais, econômicos e institucionais.
  - Construir um script stand alone em R de maneira que possa ser executado com download de todas as fontes de dados
- Justificativa:
  - Compreender as dinâmicas que influenciam a qualidade em modelos estatísticos de regressão linear múltipla.

### 2. Aspectos gerais

  #### 2.1. Estrutura do trabalho
    - Divisão da turma
Divisão da turma em 15 grupos de 7 a 10 alunos (por afinidade):

    - Contexto
Suponha que o grupo esteja realizando pesquisa que envolve aspectos do perfil socioeconômico dos municípios do estado de ___________________________. 
(cada grupo terá sorteado uma unidade da federação)

Dentre os propósitos da pesquisa, a intenção é investigar as eventuais relações entre um indicador com a taxa média de homicídios (consumados e tentados) e alguns outros fatores como o desempenho econômico municipal (medido pelo PIB per capita), sua taxa de analfabetismo e o percentual de sua jovem entre outros.

    - Granularidade da análise:
      - O nível de análise será os municípios do estado sorteado

  #### 2.2. Coleta de dados:
Utilização de fontes públicas, preferencialmente oficiais.
construa um data frame filtrado para o estado selecionado, lendo no R os dados do .csv com os dados de criminalidade previamente extraídos do SINESP VDE, da população pelo Censo 2022 conforme IBGE e uma taxa média anual calculada para 100 mil habitantes:
https://drive.google.com/file/d/12_MRBwS1QP26HpwuVAJr4cb-gylc0m5d/view?usp=drive_link 

utilize o pacote SIDRAR no R Studio para baixar dados da tabela 5938, Produto Interno Bruto a preços correntes (Mil Reais) no ano de 2023:
https://sidra.ibge.gov.br/tabela/5938 
Crie uma coluna calculada com o PIB per capita de cada município do estado sorteado

retorne aos dados da API do SIDRAR de resultados do Censo 2022 no IBGE e procure pela quantidade de aglomerados urbanos que cada município do estado possui:
https://sidra.ibge.gov.br/tabela/9883 
Baixe os dados no  SIDRAR utilizando variável  9910. Considerando que a tabela só traz dados dos municípios que tenham ao menos uma favela, modele o join de maneira que ao invés de criar NAs, os municípios sem nenhum aglomerado fiquem com o valor zerado.

acesse agora os resultados do Censo 2022 para a taxa de pessoas alfabetizadas em cada município e repita o procedimento de extração via SIDRAR:
https://sidra.ibge.gov.br/tabela/9543 
Crie uma coluna calculada com a taxa de analfabetismo municipal.

complemente os dados do Censo de 2022 com a extração do total de pessoas residentes, com idade entre 15 a 29 anos (conceito legal de jovem, conforme Lei federal 12.852/2013, utilizando a tabela 9514 do SIDRAR:
https://sidra.ibge.gov.br/tabela/9514  
Crie uma coluna calculada com o percentual da população jovem nos municípios.

usando o pacote no R denominado IPEADATAR busque pela variável "FAM_PBF", que retorna o total de famílias beneficiárias do Programa Bolsa Família em dezembro de cada ano. Filtre apenas os valores apurados para dezembro de 2024 (ou seja, a coluna date = "2025-01-01")
Crie uma coluna calculada com a taxa de recebimento do PBF para cada 100 mil habitantes.





  #### 2.3. Construção do modelo:
Insira todas as variáveis em um data frame novo no R Studio
Realize a estatística descritiva de cada uma dessas variáveis, incluindo o resumo dos 5 números, a média e o desvio-padrão e o coeficiente de variação.
(i) atestar que os dados numéricos estejam formatados como número; 
(ii) crie variáveis estandardizadas (Z_score) para cada uma das variáveis quantitativas e avalie pelo critério de afastamento em desvios-padrão se existem outliers em alguma variável

Faça testes de hipótese formais robustos para identificar a NORMALIDADE das variáveis, bem como a presença de OUTLIERS.
Agora, gere uma matriz de correlação entre a variável dependente e as variáveis independentes e interprete o valor obtido. Justifique o coeficiente de correlação escolhido e avalie a sua significância estatística. Apresente um gráfico de dispersão que apoie essa análise.

No R Studio, realize os testes dos pressupostos de uma regressão linear múltipla e analise os resultados obtidos. 

Suponha que seu TCC DE FINAL DE CURSO pretenda avaliar a possível relação entre a média de homicídios (consumados e tentados) e algumas características socioeconômicas e demográficas. A metodologia envolverá análise de regressão.
Utilize o R Studio para estimar a regressão linear múltipla sugerida pela seguinte modelagem:
𝑌𝑖 = 𝛽0 + 𝛽1. 𝑋1𝑖 + 𝛽2. 𝑋2𝑖 + 𝛽3. 𝑋3𝑖 + 𝑢𝑖	 (Modelo genérico)
tx_HOM𝑖 = 𝑏0 + 𝑏1. pib_pc + 𝑏2. qtde_favela + 𝑏3. tx_analfab + 𝑏4. perc_jovem + 𝑏5. tx_bolsa + 𝑢𝑖	
(Modelo específico)

Dos resultados obtidos desta modelagem, crie uma tabela com dados de qualidade da regressão, em um modelo típico de um artigo científico ou relatório de decisão baseada em evidência:

| Variavel | Coeficiente | Erro Padrao | Coef. Padronizados | Estatística t | p-valor(sig.) | IC95 Min | IC95 Max |
|  :--- | :---: | :---: | :---: | :---: | :---: | :---: | ---: |
| Intercepto (constante) |  |  |  |  |  |  |  |
| indep_1 |  |  |  |  |  |  |  |
| indep_2 |  |  |  |  |  |  |  |
| indep_3 |  |  |  |  |  |  |  |
| indep_4|  |  |  |  |  |  |  |
| indep_5 |  |  |  |  |  |  |  |
| n=  | R2 =  | R2 ajustado = | Estat. F = | p global = | AIC = | BIC = | Erro padrao residual |



  #### 2.4. Análise do modelo:
A partir das significâncias estatísticas (resultados dos testes de hipóteses) dos parâmetros do modelo ajustado (R2, b0, b1, b2, b3, b4 e b5), responda: 
(i) quais foram significativos a 1%? 
(ii) quais foram significativos a 5%? 
(iii) quais foram significativos a 10%? 
(iv) quais não foram significativos?
Caso algum parâmetro não tenha sido estatisticamente significativo a 10%, o que esse resultado quer dizer?
Interprete o valor do R2 ajustado. Em seguida, interprete as estimativas obtidas para cada um dos parâmetros β0, β1, β2, β3, β4 e β5. Por fim, interprete os valores dos respectivos coeficientes padronizados dos parâmetros β1,...  βi.
Interprete a estatística F e o p-valor global do modelo?
Das variáveis explicativas consideradas no modelo, qual delas apresenta maior peso na determinação da Taxa Média de Homicídios do estado sorteado? Justifique.
Interprete os intervalos de confiança obtidos para os parâmetros β0 … β5, ao nível de confiança de 95%.Algum deles cruza o valor zero entre o mínimo e o máximo? O que cruzar ou não cruzar o zero pode significar?
Avalie os resultados do teste de Inflação da Variância (VIF) do modelo.
Qual é a Taxa Média de Homicídios esperada (ou seja, a taxa mais provável) para um município que eventualmente apresente as seguintes características: (i) PIB per capita de 2 mil reais, (ii) taxa de analfabetismo de 10%, (iii) que possua “favelas e comunidades urbanas” e (iv) com percentual de jovens de 20%?

 #### 2.5. Ajuste do modelo:
Ajuste o modelo de regressão sugerido anteriormente, porém transformando as variáveis quantitativas (variável dependente e as variáveis explicativas contínuas), de modo que elas fiquem expressas em termos do seu logaritmo natural (ln). 

Utilize a técnica de ajuste do logaritmo para variáveis com valor zero. 

Em relação à variável discreta quantidade de favelas, transforme-a em uma variável binária dicotômica considerando que os municípios que não possuem favelas devem ter o campo como `0` (zero) e os que possuem 01 (uma) ou mais favela devem ter o campo como `1` (um).

tx_HOM𝑖 = 𝑏0 + 𝑏1. ln(pib_pc) + 𝑏2. ln(tx_analfab) + 𝑏3. ln(perc_jovem) + 𝑏4. ln(tx_bolsa) + 𝑏5.tem_favela + 𝑢𝑖	(Modelo específico)
Dos resultados obtidos desta nova modelagem, crie uma segunda tabela com valores de qualidade da regressão, conforme o modelo fornecido em sala de aula .
| Variavel | Coeficiente | Erro Padrao | Coef. Padronizados | Estatística t | p-valor(sig.) | IC95 Min | IC95 Max |
|  :--- | :---: | :---: | :---: | :---: | :---: | :---: | ---: |
| Intercepto (constante) |  |  |  |  |  |  |  |
| indep_1 |  |  |  |  |  |  |  |
| indep_2 |  |  |  |  |  |  |  |
| indep_3 |  |  |  |  |  |  |  |
| indep_4|  |  |  |  |  |  |  |
| indep_5 |  |  |  |  |  |  |  |
| n=  | R2 =  | R2 ajustado = | Estat. F = | p global = | AIC = | BIC = | Erro padrao residual |


A transformação das variáveis melhorou ou piorou os resultados do modelo de regressão? Justifique.

  #### 2.6. Simplificando o modelo:

Escolha uma das variáveis independentes e a retire do modelo. Justifique sua escolha.
Dos resultados obtidos desta terceira modelagem, crie uma nova tabela com valores de qualidade da regressão, conforme o modelo típico de um artigo ou relatório baseado em evidências:

| Variavel | Coeficiente | Erro Padrao | Coef. Padronizados | Estatística t | p-valor(sig.) | IC95 Min | IC95 Max |
|  :--- | :---: | :---: | :---: | :---: | :---: | :---: | ---: |
| Intercepto (constante) |  |  |  |  |  |  |  |
| indep_1 |  |  |  |  |  |  |  |
| indep_2 |  |  |  |  |  |  |  |
| indep_3 |  |  |  |  |  |  |  |
| indep_4|  |  |  |  |  |  |  |
| n=  | R2 =  | R2 ajustado = | Estat. F = | p global = | AIC = | BIC = | Erro padrao residual |


Com base na comparação dos resultados das três tabelas geradas até aqui, qual dos modelos de regressão você escolheria para apresentar como embasamento de seu projeto de intervenção? Justifique.






  #### 2.7. Customizando o modelo:
Suponha que você pensou inicialmente em simplificar o modelo, usando a variável IDH-M em substituição ao PIB per capita e à taxa de analfabetismo. Porém, diante do atraso de dados na sua atualização (atualmente só existe IDH Municipal com dados do Censo de 2010), você decide criar uma variável proxy que tente projetar um índice com os componentes clássicos do IDH (renda, educação e nível de saneamento).
aproveite os dados já baixados de renda (PIB) e educação (analfabetismo) e some a ele uma extração relativa ao percentual de domicílios do município que possuem lixo coletado por serviço de limpeza (72120) na tabela SIDRAR 9541:
https://sidra.ibge.gov.br/tabela/9541  

busque também o percentual de domicílios do município que possuem esgoto conectado à rede (72110) na tabela SIDRAR 9397:
https://sidra.ibge.gov.br/tabela/9397   

Crie os z_score dessas quatro variáveis:
mutate( z_renda = as.numeric(scale(pib_pc)),
    z_educacao = as.numeric(-scale(taxa_analf)), #polaridade invertida
    z_saneamento = as.numeric(scale(perc_saneamento)),
    z_lixo = as.numeric(scale(perc_lixo)) )
Una os quatro z_score em uma variável final:
 mutate( idh_proxy_2022 = mean(  c(z_renda, z_educacao, z_saneamento, z_lixo),  na.rm = TRUE     )

Atualize seu modelo regressivo, incluindo indice_proxy e removendo pib_pc e analfab:
tx_HOM𝑖 = 𝑏0 + 𝑏1. indice_proxy + 𝑏2. favela+ 𝑏3. perc_jovem + 𝑏4. tx_bolsa_fam + 𝑢𝑖
(Modelo específico)
Dos resultados obtidos desta quarta modelagem, crie mais uma tabela com valores de qualidade da regressão, conforme o modelo fornecido em sala de aula .
| Variavel | Coeficiente | Erro Padrao | Coef. Padronizados | Estatística t | p-valor(sig.) | IC95 Min | IC95 Max |
|  :--- | :---: | :---: | :---: | :---: | :---: | :---: | ---: |
| Intercepto (constante) |  |  |  |  |  |  |  |
| indep_1 |  |  |  |  |  |  |  |
| indep_2 |  |  |  |  |  |  |  |
| indep_3 |  |  |  |  |  |  |  |
| indep_4|  |  |  |  |  |  |  |
| n=  | R2 =  | R2 ajustado = | Estat. F = | p global = | AIC = | BIC = | Erro padrao residual |

Com base na comparação dos resultados das quatro tabelas, qual dos modelos de regressão você escolheria para apresentar como embasamento de seu projeto de intervenção? Justifique.

## 3. Prazo de entrega
Os grupos terão até o dia 31 de maio para entregar o trabalho.
Não é necessário encaminhar arquivos via email. 
A entrega deverá ser procedida através do envio via MOODLE online:
arquivo em .pdf contendo as respostas, incluindo prints de tabelas e gráficos, quando julgar necessário.
arquivo .R com todas as consultas às bases de dados, tratamentos, junções, variáveis de apoio, gráficos e modelos estatísticos utilizados no relatório. 




Frederico Martins de Paula Neto, MSc.
Professor de disciplina de estatística
