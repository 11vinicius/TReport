#INCLUDE 'TOTVS.CH'


User Function TReport2()
    PRIVATE cTitulo    := "Relatório de Autores"
    PRIVATE cDescri    := "Emissão de Relatório de Autores"
    PRIVATE cFunName   := FunName()
    PRIVATE cRelatorio := ReportDef()

    cRelatorio:PrintDialog()
Return 


Static Function ReportDef()
    LOCAL oReport 

    oReport    := TReport():New(cFunName, cTitulo, ,{|oReport| PrintReport(oReport) }, cDescri)
    oSection1  := TRSection():New(oReport,'Livro',{'Sz4,SZ3,SZ2'},)
    TRCell():New(oSection1,"Z4_TITULO","SZ4",,,30)
    TRCell():New(oSection1,"Z4_NOME","SZ2",,,30)
    TRCell():New(oSection1,"Z3_NOME","SZ3",,,30)
    TRCell():New(oSection1,"Z4_EDICAO","SZ4",,,30)
    TRCell():New(oSection1,"Z4_ANO","SZ4",,,30)

    TRPosition():New(oSection1,'SZ2',1,{|| SZ4->Z4_AUTOR})
    TRPosition():New(oSection1,'SZ3',1,{|| SZ4->Z4_EDITORA})

Return oReport 

Static Function PrintReport(oReport)
    Local oSection1 := oReport:Section(1)

    SZ4->(DBSETORDER(1))
    SZ4->(DBGOTOP())

    oSection1:Print()
Return
