# Baixar shape file das unidades federativas brasileiras

link <- "ftp://geoftp.ibge.gov.br/organizacao_do_territorio/malhas_territoriais/malhas_municipais/municipio_2016/Brasil/BR/"
link_estados = paste0(link, "br_unidades_da_federacao.zip")

download.file(link_estados, destfile = "shp_uf.zip")
unzip("shp_uf.zip")