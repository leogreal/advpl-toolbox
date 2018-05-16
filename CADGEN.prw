#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} CADGEN
Função para cadastro generico
@author Leonardo Gregorio de Almeida
@since 07/05/2018
@return Nil, Função não tem retorno
/*/
User Function CADGEN()

	If Type("cEmpAnt") == "U"
		MsApp():New("SIGAESP")
		oApp:CreateEnv()
		oApp:Activate({|| fPrincipal(), Final() })
	Else
		fPrincipal()
	EndIf

Return()

/*---------------------------------------------------------------------*
 | Static Function: fPrincipal                                         |
 *---------------------------------------------------------------------*/
Static Function fPrincipal()
	
	Private oDlg := Nil
	Private cTitulo := " Cadastro Genérico"
	Private aGrupos := {}
	Private oCSS := TCSS():New()
	Private oTCadGen := TCadGen():New()
	Private oFontLab := TFont():New("Arial",,28,,.T.,,,,,.F.,.F.)
	Private oFontCab := TFont():New("Arial",,20,,.T.,,,,,.F.,.F.)
	Private oFontTxt := TFont():New("Arial",,14,,.T.,,,,,.F.,.F.)
	Private oFontSml := TFont():New("Arial",,08,,.T.,,,,,.F.,.F.)
	Private oSize := FwDefSize():New(.T.)
	oSize:lProp := .T. // Proporcional
	oSize:aMargins := {5,5,5,5} // Espaco ao lado dos objetos
	oSize:AddObject("CAB",100,50,.T.,.T.)
	oSize:AddObject("ITE",100,50,.T.,.T.)
	oSize:Process() // Dispara os calculos
	
	
	oDlg := TDialog():New(oSize:aWindSize[1],oSize:aWindSize[2],oSize:aWindSize[3],oSize:aWindSize[4],;
		cTitulo,,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	oTBar := TBar():new(oDlg,025,032,.T.,Nil,Nil,"FND_LGND",.F.)
	oTBar:nHeight := 30
	
	TSay():New(010,010,{|| cTitulo },oTBar,,oFontLab,,,,.T.,CLR_BLACK,CLR_WHITE,400,10)
	
	oBtSair := TButton():New(000,000," Sair",oTBar,{|| oDlg:End() },60,16,,,.F.,.T.,.F.,,.F.,,,.F.)
	oBtSair:align := 2 //Alinha pela direita
	oBtSair:SetCss(oCSS:QPushButton("FINAL.png"))
	
	//-8-12
	oPnCab := TPanel():New(;
		oSize:GetDimension("CAB","LININI"),oSize:GetDimension("CAB","COLINI"),;
		"Grupos",oDlg,,,,CLR_BLACK,CLR_WHITE,;
		oSize:GetDimension("CAB","XSIZE"),oSize:GetDimension("CAB","YSIZE"),.T.)
		
	oBwGrupo := FWBrowse():New(oPnCab)
	oBwGrupo:SetDataArray()
	oBwGrupo:SetArray(aGrupos)
	oBwGrupo:nAt := 1
	oBwGrupo:AddColumn({"Chave",{ || aGrupos[oBwGrupo:nAt]:cGRUPO },"C","@!","LEFT",10,0,.F.})
	oBwGrupo:AddColumn({"Descrição",{ || aGrupos[oBwGrupo:nAt]:cDESC },"C","@!","LEFT",50,0,.F.})
	oBwGrupo:AddColumn({"Complemento",{ || aGrupos[oBwGrupo:nAt]:cCOMPLE },"C","@!","LEFT",50,0,.F.})
	oBwGrupo:DisableReport()
	oBwGrupo:DisableConfig()
	oBwGrupo:DisableSeek()
	oBwGrupo:Disable()
	oBwGrupo:Activate()
	
	oPnIte := TPanel():New(;
		oSize:GetDimension("ITE","LININI"),oSize:GetDimension("ITE","COLINI"),;
		"Itens",oDlg,,,,CLR_BLACK,CLR_WHITE,;
		oSize:GetDimension("ITE","XSIZE"),oSize:GetDimension("ITE","YSIZE"),.T.)
	
	fListaGrupos()
	oDlg:Activate(,,,.T.,{|| MsgYesNo("Deseja realmente sair?","Atenção") },,{|| .t.})
		
Return

/*---------------------------------------------------------------------*
 | Static Function: fListaGrupos                                       |
 *---------------------------------------------------------------------*/
Static Function fListaGrupos()

	aGrupos := {}
	MsgYesno(VARINFO("oTCadGen",oTCadGen,,.F.,.F.))
	
	aGrupos := oTCadGen:listByGrp("0000000000")
	
	oBwGrupo:SetArray(aGrupos)
	
	MsgYesno(VARINFO("aGrupos",aGrupos,,.F.,.F.))
	
	If Empty(aGrupos)
		oBwGrupo:nAt := 0
		oBwGrupo:Disable()
	Else
		oBwGrupo:nAt := 1
		oBwGrupo:Enable()
	EndIf
	oBwGrupo:Refresh()
	oPnCab:Refresh()

Return()
