#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} CADGEN
Função para cadastro generico
@author Leonardo Gregorio de Almeida
@since 24/04/2018
@return Nil, Função não tem retorno
@obs Não se pode executar função dentro do fórmulas
/*/
User Function CADGEN()

Private _aLGrupo   := {}
Private _aLChave   := {}
Private _cChave    := Space(60)


PREPARE Environment EMPRESA "01" FILIAL "01" MODULO "FIN" TABLES "ZPR"

SetPrvt("_oDlg","_oLbLGrupo","_oLbLChave")

Define MsDialog _oDlg Title "Cadastro da Tabela Generica (ZPR)" From 000,000 To 700,1000 Pixel

@ 002,002 TO 150,500 Title "Grupos"
@ 040,005	ListBox _oLbLGrupo Fields Header	"CHAVE","DESCRICAO","DESCRICAO 2" Size 490,100 Of _oDlg Pixel
aadd(_aLGrupo,oZPR010():New())
loadList("G")

@ 010,005 SAY "Chave" OBJECT _oLbGrupo
@ 020,005 GET _cChave SIZE 90,10 OBJECT _oPreFix

@ 020,105 Button "Buscar"	  	    Size 60,10 Action Processa({|| listaGrupo(_cChave) }) Object _oBtoFind
@ 020,170 Button "Incluir"  		  Size 60,10 Action Processa({|| zprtela("G") } )  Object _oBtIncGrp
@ 020,235 Button "Alterar"  		  Size 60,10 Action Processa({|| zprtela("G",_aLGrupo[_oLbLGrupo:nAt]) }) Object _oBtAltGrp
@ 020,300 Button "Excluir"  		  Size 60,10 Action Processa({|| excluir("G",_aLGrupo[_oLbLGrupo:nAt]) }) Object _oBtDelGrp

@ 160,002 TO 350,500 Title "Chaves"
@ 190,005	ListBox _oLbLChave Fields Header	"GRUPO","CHAVE","CODIGO GENERICO","DESCRICAO" Size 490,155 Of _oDlg Pixel
aadd(_aLChave,oZPR010():New())
loadList("C")

@ 170,105 Button "Incluir"  		  Size 60,10 Action Processa({|| zprtela("C") } )  Object _oBtIncCha
@ 170,170 Button "Alterar"  		  Size 60,10 Action Processa({|| zprtela("C",_aLChave[_oLbLChave:nAt]) }) Object _oBtAltCha
@ 170,235 Button "Excluir"  		  Size 60,10 Action Processa({|| excluir("C",_aLChave[_oLbLChave:nAt]) }) Object _oBtDelCha

Activate MsDialog _oDlg Centered

Return
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³STATIC FUNCTION ³  LOADLISTT                                           ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³ CARREGA O LIST BOX                                                    ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Parametros³  _cTipoList                                                ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Retorno   ³                                                            ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function loadList(_cTipoList)
//Valido se é uma lista de grupo ou de chave
If _cTipoList == "G"
	_oLbLGrupo:SetArray(_aLGrupo)
	_oLbLGrupo:bLine:={||{;
	_aLGrupo[_oLbLGrupo:nAt]:czprCHAVE ,;
	SUBSTRING(_aLGrupo[_oLbLGrupo:nAt]:czprGENERI,1,100),;
	_aLGrupo[_oLbLGrupo:nAt]:czprDESC }}
	_oLbLGrupo:bLDblClick := {|| listaChave(	_aLGrupo[_oLbLGrupo:nAt]:czprCHAVE)}
	_oLbLGrupo:Refresh()
ElseIf _cTipoList == "C"
	_oLbLChave:SetArray(_aLChave)
	_oLbLChave:bLine:={||{;
	_aLChave[_oLbLChave:nAt]:czprGRUPO ,;
	_aLChave[_oLbLChave:nAt]:czprCHAVE ,;
	SUBSTRING(_aLChave[_oLbLChave:nAt]:czprGENERI,1,100),;
	_aLChave[_oLbLChave:nAt]:czprDESC }}
	_oLbLChave:bLDblClick := {|| zprtela("C",_aLChave[_oLbLChave:nAt])}
	_oLbLChave:Refresh()
EndIf
Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³STATIC FUNCTION ³  LISTAGRUPO                                          ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³                                                                       ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Parametros³ _cChave                                                    ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Retorno   ³                                                            ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function listaGrupo(_cChave)
Local _cInPrefix
Local _oDZPR := oDZPR010():New()

//Valida se foi preenchido o filtro chave
If _cChave == Nil .or. Empty(Alltrim(_cChave))
	_aLGrupo := _oDZPR:listByGrp("0000000000")
Else
	_aLGrupo := _oDZPR:listByChv("0000000000",_cChave)
EndIf
//Valida se a Lista esta em branco
If(Len(_aLGrupo) <= 0)
	aadd(_aLGrupo,oZPR010():New())
EndIf
loadList("G")
listaChave(	_aLGrupo[_oLbLGrupo:nAt]:czprCHAVE)
Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³STATIC FUNCTION ³  LISTACHAVE                                          ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³                                                                       ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Parametros³ _cGrupo                                                    ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Retorno   ³                                                            ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function listaChave(_cGrupo)
Local _cInPrefix
Local _aPreFix := {}
Local _oDZPR := oDZPR010():New()

_aLChave := _oDZPR:listByGrp(_cGrupo)

//Valida se a Lista esta em branco
If(Len(_aLChave) <= 0)
	aadd(_aLChave,oZPR010():New())
EndIf
loadList("C")

Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³STATIC FUNCTION ³  zprtela                                             ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³                                                                       ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Parametros³ _xZPR, _cTipoList                                          ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Retorno   ³                                                            ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Static Function zprtela(_cTipoList,_xZPR)
Local _aZPR      := {}
Local _oZPR
Local _lContinua := .T.
Local _oDZPR     := oDZPR010():New()
Local _lAltera   := .F.


//Valida se foi passado um objeto para alteracao e se refere a grupo ou chave
If(_xZPR == NIL .and. _cTipoList == "G")
	_oZPR           := oZPR010():New()
	_oZPR:czprGRUPO := "0000000000"
ElseIf(_xZPR == NIL .and. _cTipoList == "C")
	//Valido Se foi selecionado um grupo
	If _aLGrupo[_oLbLGrupo:nAt]:czprCHAVE == Nil .OR. Empty(Alltrim(_aLGrupo[_oLbLGrupo:nAt]:czprCHAVE))
		MsgBox("Favor selecionar um grupo antes de inserir uma chave.")
		_lContinua := .F.
	EndIf
	_oZPR := oZPR010():New()
	_oZPR:czprGRUPO := _aLGrupo[_oLbLGrupo:nAt]:czprCHAVE
ElseIf _xZPR != NIL
	_oZPR    := _xZPR
	_lAltera := .T.
EndIf


If _lContinua .and. _oZPR != Nil
	SetPrvt("_oDlgInc","_oGChave","_oBtoFind")
	
	Define MsDialog _oDlgInc Title "Incluir no Grupo: " + AllTrim(_aLGrupo[_oLbLGrupo:nAt]:czprGENERI) From 000,000 To 200,600 Pixel
	//Mudo os label conforme o tipo de cadastro se eh de grupo ou de chave
	@ 010,005 SAY If(_cTipoList == "G","Grupo","Chave") OBJECT  _oLbChave
	@ 020,005 GET _oZPR:czprCHAVE   SIZE  40,10  OBJECT _oGChave Valid validaGrupo(_cTipoList,_oZPR)
	//Valido se eh alteracao de grupo para nao deixar alterar o codigo do grupo
	If _lAltera
		_oGChave:Disable()
	EndIf
	//Mudo os label conforme o tipo de cadastro se eh de grupo ou de chave
	@ 030,005 SAY If(_cTipoList == "G","Descricao","Codig Generico")  OBJECT _oLbGen
	@ 040,005 GET _oZPR:czprGENERI  SIZE 250,10  OBJECT _oGGener
	//Mudo os label conforme o tipo de cadastro se eh de grupo ou de chave
	@ 050,005 SAY If(_cTipoList == "G","Descricao 2","Descricao")     OBJECT _oLbDesc
	@ 060,005 GET _oZPR:czprDESC    SIZE 250,10  OBJECT _oGDesc
	
	
	@ 080,005 Button "Gravar" Size 60,10 Action (Processa({|| _oDZPR:salvarZPR(_oZPR) }),listaGrupo(_cChave),_oDlgInc:End()) Object _oBtoGrv
	
	Activate MsDialog _oDlgInc Centered
EndIf
Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³STATIC FUNCTION ³  validaGrupo                                         ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³ Valida se ja existe grupo cadastrado com o codigo escolhido           ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Parametros³ _cTipoList,_xZPR                                           ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Retorno   ³                                                            ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Static Function validaGrupo(_cTipoList,_xZPR)
Local _lReturn := .T.
Local _oDZPR := oDZPR010():New()
//So valida se for cadastro de grupo
If _cTipoList == "G"
	//Verifico se possue algum grupo com essa chave
	If Len(_oDZPR:listByGrp(_xZPR:czprCHAVE)) > 0
		_lReturn := .F.
		MsgBox("Ja existe um grupo cadastrado com esse codigo")
	EndIf
ElseIf _cTipoList == "C"
	//Verifico se possue algum grupo com essa chave
	If Len(_oDZPR:listByChv(_xZPR:czprGRUPO,_xZPR:czprCHAVE)) > 0
		_lReturn := .F.
		MsgBox("Ja existe um chave desse grupo cadastrado com esse codigo")
	EndIf
EndIF
Return _lReturn


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³STATIC FUNCTION ³  validaChave                                         ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³ Valida se ja existe chave cadastrado com o codigo escolhido           ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Parametros³ _cTipoList,_xZPR                                           ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Retorno   ³                                                            ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Static Function validaChave(_cTipoList,_xZPR)
Local _lReturn := .T.
Local _oDZPR := oDZPR010():New()

Return _lReturn

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³STATIC FUNCTION ³  excluir                                             ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³ Valida se ja existe grupo cadastrado com o codigo escolhido           ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Parametros³ _cTipoList,_xZPR                                           ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Retorno   ³                                                            ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Static Function excluir(_cTipoList,_xZPR)
Local _lReturn := .T.
Local _oDZPR := oDZPR010():New()
Local _aChave := {}
//Solicito confirmacao do usuario
If !MsgBox("Deseja Realmente exluir esse item?","Alerta","YESNO")
	Return
Endif
//So valida se for cadastro de grupo
If _cTipoList == "G" .and. _xZPR != Nil
	_aChave := _oDZPR:listByGrp(_xZPR:czprCHAVE)
	//processo todas as chaves cadastradas para esse grupo e excluo
	For x:= 1 to  Len(_aChave)
		_oDZPR:excluirZPR(_aChave[x]:nzprRecno)
	Next x
	_oDZPR:excluirZPR(_xZPR:nzprRecno)
ElseIf _cTipoList == "C" .and. _xZPR != Nil
	_oDZPR:excluirZPR(_xZPR:nzprRecno)
EndIF
listaGrupo(_cChave)
Return
