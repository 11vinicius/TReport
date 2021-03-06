#INCLUDE 'TOTVS.CH'


User Function TReport()
    PRIVATE cTitulo    := "Relat�rio de Autores"
    PRIVATE cDescri    := "Emiss�o de Relat�rio de Autores"
    PRIVATE cFunName   := FunName()
    PRIVATE cRelatorio := ReportDef()

    cRelatorio:PrintDialog()
Return 


Static Function ReportDef()
    LOCAL oReport 

    oReport    := TReport():New(cFunName, cTitulo, ,{|oReport| PrintReport(oReport) }, cDescri)
    oSection1  := TRSection():New(oReport,'Produto',{'SB1'},{'C�digo','tipo','Nome'})
    TRCell():New(oSection1,"B1_COD","SB1")
    TRCell():New(oSection1,"B1_TIPO","SB1")
    TRCell():New(oSection1,"B1_DESC","SB1")
Return oReport 

Static Function PrintReport(oReport)
    Local oSection1 := oReport:Section(1)

    SB1->(DBSETORDER(oReport:nOrder))
    SB1->(DBGOTOP())

    oSection1:Print()
Return
