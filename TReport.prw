#INCLUDE 'PROTHEUS.CH'

#DEFINE ENTER CHR(13)+CHR(10)

User Function RELSA1()
    Private cPerg := "RELSA1"
    Private cNextAlias := GetnextAlias()

    ValidPerg(cPerg)

    If Pergunte(cPerg,.T.)
        oReport := ReportDef()
        oReport:PrintDialog()
    endIf

Return 

Static Function ReportDef()
    oReport:= TReport():New(cPerg,"Relatório de Cliente por Estado",cPerg,{|oReport|ReportPrint(oReport)},"Impressão de relatório por estado")
    oReport:SetLandscape(.T.)
    oReport:HideParamPage()

    oSection := TRSection():New(oReport,OEMToAnsi("Relatório de Cliente por Estado"),{'SA1'})
    TRCELL():New(oSection,  "A1_COD",   cNextAlias,"Codigo",,,,)
    TRCELL():New(oSection,  "A1_NOME",  cNextAlias,"Nome",,,,)
    TRCELL():New(oSection,  "PESSOA",   cNextAlias,"Pessoa",,,,)
    TRCELL():New(oSection,  "A1_END",   cNextAlias,"Endereço",,,,)
    TRCELL():New(oSection,  "A1_BAIRRO",cNextAlias,"Bairro",,,,)
    TRCELL():New(oSection,  "A1_EST",   cNextAlias,"Estado",,,,)
    TRCELL():New(oSection,  "A1_CEP",   cNextAlias,"Cep",,,,)
    TRCELL():New(oSection,  "A1_MUN",   cNextAlias,"Municipio",,,,)

Return oReport

Static Function ReportPrint(OReport)
    Local oSection := oReport:Section(1)
    Local cQuery := ""
    Local nCount := 0

    cQuery += "select " + ENTER
    cQuery += " A1_COD, " + ENTER
    cQuery += " A1_NOME, " + ENTER
    cQuery += " A1_PESSOA, " + ENTER
    cQuery += " A1_END, " + ENTER
    cQuery += " A1_BAIRRO, " + ENTER
    cQuery += " A1_EST, " + ENTER
    cQuery += " A1_CEP, " + ENTER
    cQuery += " A1_MUN " + ENTER

    cQuery += " from "+ RetSQLNAME('SA1') + " where D_E_L_E_T_ = '' " + ENTER
    iF !EMPTY(MV_PAR01)
        cQuery += " AND A1_EST = '" + UPPER(MV_PAR01) + "' " + ENTER
    EndIf    

    cQuery += " ORDER BY A1_EST , A1_COD"

    DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cNextAlias)

    Count to nCount 
    (cNextAlias)->(dbgotop())
    oReport:SetMEter(nCount)
    oSection:init(dbgotop())

    while !(cNextAlias)->(Eof())
        oReport:IncMeter(nCount)
        osection:Printline()
            if oReport:Cancel()
                exit
            endif
        (cNextAlias)->(DbSkip())
    endDo
Return 

Static Function ValidPerg(cPerg)
    Local aAlias := GetArea()
    Local aRegs := {}
    Local i,j

    cPerg := PadR(cPerg,Len(SX1->X1_GRUPO), " ")

    // Aadd(_aRegs,{_cPerg,"01","Dt emissão inicial            ","                              ","                              ","mv_ch1","D",08,0,0,"G","                                                            ","mv_par01       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","          ","                                                            ","   ","S","   ","          "})
       Aadd(aRegs, {cperg, "01","Estado                        ","                              ","                              ",MV_PAR01,"C",2,0,0 ,"G","                                                            ","MV_PAR01       ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","               ","                                                            ","               ","               ","               ","      12    ","                                                            ","   ","S","   ","          "})
    DbSelectArea('SX1')
    SX1->(DbSetOrder(1))

    FOR i:= 1 to Len(aRegs)
        if !Dbseek(cPerg+aRegs[i,2])
            RecLock('SX1',.T.)
                FOR j := 1 to FCount()
                    FieldPut(j,aRegs[i,j])
                Next
             MsUnlock()
        ENDIF
    NEXT

    RestArea(aAlias)                
Return 
