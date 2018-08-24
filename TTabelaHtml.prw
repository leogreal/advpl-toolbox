#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

/*---------------------------------------------------------------------*
 | Class: TTabelaHtml                                                  |
 | Description: Monta uma tabela em Html                               |
 *---------------------------------------------------------------------*/
User Function TabHtml()

	Local _oTbHtml := Nil
	Local _aDados := {}
	Local _cHtml := ""
	
	aAdd(_aDados,{"Descrição", "Data", "Valor"})
	
	aAdd(_aDados,{;
		{"José","@!",30},;
		{Date(), "", 30},;
		{1.99, "@E 999,999.99", 40};
	})
	aAdd(_aDados,{;
		{"Ana","@!",30},;
		{Date(), "", 30},;
		{500, "@E 999,999.99", 40};
	})
	aAdd(_aDados,{;
		{"Felipe","@!",30},;
		{Date(), "", 30},;
		{20, "@E 999,999.99", 40};
	})
	
	
	_oTbHtml := TTabelaHtml():New(_aDados)
	_oTbHtml:lErroConsole := .F.
		
	_cHtml := _oTbHtml:GeraTabela()
	
	
	_oDlg := TDialog():New(100,000,400,500,"Exemplo TTabelaHtml" ,,,,,CLR_BLACK,CLR_WHITE,,,.T.)  
	_oPn := TPanel():New(005,005,"Exemplo TTabelaHtml",_oDlg,,,,CLR_BLACK,CLR_WHITE,240,120) 
	TSay():New(010,005,{|| _cHtml },_oPn,,/*_oFontTxt*/,,,,.T.,CLR_BLACK,CLR_WHITE,230,105,,,,,,.T.)
	
	_oDlg:Activate(,,,.T.,{|| .t.},,{|| .T.})
	
Return

Class TTabelaHtml
	
	//Dados
	Data aTabela as Array
	
	//Configurações
	Data lErroConsole as Boolean
	
	//Metodos da Classe
	Method New() CONSTRUCTOR
	Method GeraTabela()
	
	//Metodos Internos
	Method Valida()
	Method ExibeErro()
	
EndClass

/*---------------------------------------------------------------------*
 | Method: New                                                         |
 *---------------------------------------------------------------------*/
Method New(aTabela) Class TTabelaHtml

	Default aTabela := {}
	Self:lErroConsole := .T.
	
	Self:aTabela := aTabela
	
Return(Self)

/*---------------------------------------------------------------------*
 | Method: GeraTabela                                                  |
 *---------------------------------------------------------------------*/
Method GeraTabela() Class TTabelaHtml
	
	Local _cTabela := ""
	Local _nI := 0
	Local _nJ := 0
	Local _nK := 0
	
	If .NOT. Self:Valida()
		Return _cTabela := ""
	EndIf
	
	_cTabela += " <table border='1' style='border-collapse: collapse' cellpadding='0' cellspacing='0' width='100%'> "
	_cTabela += "  <tr> "
	For _nJ := 1 To Len(Self:aTabela[1])
		_cTabela += " <td width='10%' align='LEFT' class='itens'><b>" + Self:aTabela[1][_nJ] + "</b></td> "
	Next _nJ
	_cTabela += "  </tr> "
	
	For _nI:= 2 To Len(Self:aTabela)	
		_cTabela += "<tr>"
		For _nK:= 1 To Len(Self:aTabela[_nI])
			If ValType(Self:aTabela[_nI][_nK][1]) == "C"
				_cTabela	 += "<td width='"+cValToChar(Self:aTabela[_nI][_nK][3])+"%' align='LEFT' class='itens'>"   + Self:aTabela[_nI][_nK][1] + "</td> "
			ElseIf ValType(Self:aTabela[_nI][_nK][1]) == "D"
				_cTabela	 += "<td width='"+cValToChar(Self:aTabela[_nI][_nK][3])+"%' align='LEFT' class='itens'>"   + Day2Str(Self:aTabela[_nI][_nK][1]) + "/" + Month2Str(Self:aTabela[_nI][_nK][1]) + "/" + Year2Str(Self:aTabela[_nI][_nK][1]) + "</td> "
			ElseIf ValType(Self:aTabela[_nI][_nK][1]) == "N"
				// TODO: Acrescentar no Self:aTabela uma picture					
				If .NOT. Empty(Self:aTabela[_nI][_nK][2])
					_cTabela += "<td width='"+cValToChar(Self:aTabela[_nI][_nK][3])+"%' align='RIGHT' style='padding-right: 10px;' class='itens'>"   + Transform(Self:aTabela[_nI][_nK][1],Self:aTabela[_nI][_nK][2]) + "</td> "
				Else
					_cTabela += "<td width='"+cValToChar(Self:aTabela[_nI][_nK][3])+"%' align='RIGHT' style='padding-right: 10px;' class='itens'>"   + cValToChar(Self:aTabela[_nI][_nK][1]) + "</td> "
				Endif
			Endif
		Next _nK
		_cTabela  += "  </tr> "
	Next _nI
	
	_cTabela += " </table> "
	
Return(_cTabela)

/*---------------------------------------------------------------------*
 | Method: Valida                                                      |
 *---------------------------------------------------------------------*/
Method Valida() Class TTabelaHtml
	
	If Empty(Self:aTabela)
		Self:ExibeErro("A lista está vazia.")
		Return(.F.)
	EndIf
	
	If ValType(Self:aTabela) != "A"
		Self:ExibeErro("A lista não é um Array.")
		Return(.F.)
	EndIf
	
Return(.T.)

/*---------------------------------------------------------------------*
 | Method: ExibeErro                                                   |
 *---------------------------------------------------------------------*/
Method ExibeErro(_cMsg) Class TTabelaHtml
	
	If Self:lErroConsole
		ConOut(_cMsg)
	Else
		MessageBox(_cMsg,"Atenção",48)
	EndIf
	
Return(Self)
