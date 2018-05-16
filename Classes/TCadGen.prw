#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} TCADGEN
Função para manipulação dos dados do cadastro generico
@author Leonardo Gregorio de Almeida
@since 16/05/2018
@return Nil, Função não tem retorno
/*/
User Function TCADGEN()
Return()

/*---------------------------------------------------------------------*
 | Class: oCadGen                                                      |
 *---------------------------------------------------------------------*/
Class oCadGen

// atributos
Data cFILIAL   	as String    //Filial do Sistema
Data cGRUPO    	as String    //Generico
Data cCHAVE    	as String    //Chave
Data cGENERI   	as String    //Generico
Data cDESC     	as String    //Descricao
Data cCOMPLE   	as String    //Descricao
Data nRECNO    	as Float     //Registro unico - id principal

// metodos
Method new() CONSTRUCTOR
EndClass

/*---------------------------------------------------------------------*
 | Method: New                                                         |
 *---------------------------------------------------------------------*/
Method New() Class oCadGen

	::cFILIAL 	:= Space(2)
	::cGRUPO  	:= Space(10)
	::cCHAVE  	:= Space(10)
	::cGENERI 	:= Space(250)
	::cDESC   	:= Space(50)
	::cCOMPLE 	:= Space(100)
	::nRECNO  	:= 0

Return Self

/*---------------------------------------------------------------------*
 | Class: TCadGen                                                      |
 *---------------------------------------------------------------------*/
Class TCadGen From TSQL

	// metodos
	Method new() CONSTRUCTOR
	Method salvar()
	Method excluir()
	Method getByRecno()
	Method listByGrp()
	Method listByChv()
	Method ChvToIn()
	Method getTabelaGenerica()
	Method getChave()
	Method nextChaveGrupo()
	Method validaGrupoChave()

EndClass

/*---------------------------------------------------------------------*
 | Method: new                                                         |
 *---------------------------------------------------------------------*/
Method new() Class TCadGen
Return Self

/*---------------------------------------------------------------------*
 | Method: salvar                                                      |
 *---------------------------------------------------------------------*/
Method salvar(_oObjeto) Class TCadGen

	Private _aRet := {0,"Problema ao salvar os dados!"}
	dbSelectArea("ZPR")

	//caso recno seja igual a zero, estou fazendo uma insercao, caso contrario uma alteracao
	If _oObjeto:nRecno == 0

		RecLock("ZPR",.T.)
		ZPR->ZPR_FILIAL 	:= _oObjeto:cFILIAL
		ZPR->ZPR_GRUPO  	:= _oObjeto:cGRUPO
		ZPR->ZPR_CHAVE  	:= _oObjeto:cCHAVE
		ZPR->ZPR_GENERI 	:= _oObjeto:cGENERI
		ZPR->ZPR_DESC   	:= _oObjeto:cDESC
		ZPR->ZPR_COMPLE 	:= _oObjeto:cCOMPLE
		MsUnLock("ZPR")

		_aRet := {ZPR->(Recno()),"Registro inserido!"}

	Else

		cQuery := " UPDATE ZPR010 SET "
		cQuery += " ZPR_FILIAL =	 '"+_oObjeto:cFILIAL+"', "
		cQuery += " ZPR_GRUPO  =	 '"+_oObjeto:cGRUPO +"', "
		cQuery += " ZPR_CHAVE  =	 '"+_oObjeto:cCHAVE +"', "
		cQuery += " ZPR_GENERI =	 '"+_oObjeto:cGENERI+"', "
		cQuery += " ZPR_DESC   =	 '"+_oObjeto:cDESC+"', "
		cQuery += " ZPR_COMPLE =	 '"+_oObjeto:cCOMPLE+"' "
		cQuery += " WHERE R_E_C_N_O_ = "+Alltrim(Str(_oObjeto:nRecno))

		::RunQuery(cQuery,"")

		_aRet := {_oObjeto:nRecno,"Registro alterado!"}

	Endif

Return _aRet

/*---------------------------------------------------------------------*
 | Method: excluir                                                     |
 *---------------------------------------------------------------------*/
Method excluir(_nRecno) Class TCadGen

	cQuery := " UPDATE ZPR010 SET D_E_L_E_T_ = '*' WHERE R_E_C_N_O_ = "+Alltrim(STR(_nRecno))
	::RunQuery(cQuery,"",.F.)

Return

/*---------------------------------------------------------------------*
 | Method: getByRecno                                                  |
 *---------------------------------------------------------------------*/
Method getByRecno(_nRecno) Class TCadGen

	Private _oObjeto
	dbSelectArea("ZPR")
	ZPR->(dbGoTo(_nRecno))
	If (! Eof())
		_oObjeto    := oCadGen():New()
		_oObjeto:cFILIAL := ZPR->ZPR_FILIAL
		_oObjeto:cGRUPO  := ZPR->ZPR_GRUPO
		_oObjeto:cCHAVE  := ZPR->ZPR_CHAVE
		_oObjeto:cGENERI := ZPR->ZPR_GENERI
		_oObjeto:cDESC   := ZPR->ZPR_DESC
		_oObjeto:cCOMPLE := ZPR->ZPR_COMPLE
		_oObjeto:nRECNO  := _nRecno
	Endif

Return _oObjeto

/*---------------------------------------------------------------------*
 | Method: listByGrp                                                   |
 *---------------------------------------------------------------------*/
Method listByGrp(cGRUPO ) Class TCadGen

	Local _aRet := {}
	Local _cTrb := GetNextAlias()

	cQuery := " SELECT * FROM ZPR010 WHERE D_E_L_E_T_ = '' "
	cQuery += " AND ZPR_FILIAL =	 '' "
	cQuery += " AND ZPR_GRUPO  =	 '"+cGRUPO +"' "
	cQuery += " ORDER BY ZPR_GRUPO, ZPR_CHAVE "

	::RunQuery(cQuery,_cTrb,.F.)

	While (_cTrb)->(!Eof())

		_oObjeto    := oCadGen():New()
		_oObjeto:cFILIAL 		:=	(_cTrb)->ZPR_FILIAL
		_oObjeto:cGRUPO  		:=	(_cTrb)->ZPR_GRUPO
		_oObjeto:cCHAVE  		:=	(_cTrb)->ZPR_CHAVE
		_oObjeto:cGENERI 		:=	(_cTrb)->ZPR_GENERI
		_oObjeto:cDESC   		:=	(_cTrb)->ZPR_DESC
		_oObjeto:cCOMPLE  		:=	(_cTrb)->ZPR_COMPLE
		_oObjeto:nRECNO 	 		:=	(_cTrb)->R_E_C_N_O_

		aadd(_aRet,_oObjeto)
		(_cTrb)->(dbSkip())
	End

	(_cTrb)->(dbCloseArea())

Return _aRet

/*---------------------------------------------------------------------*
 | Method: listByChv                                                   |
 *---------------------------------------------------------------------*/
Method listByChv(cGRUPO ,cCHAVE ) Class TCadGen

	Local _cTrb := GetNextAlias()
	Local _aRet := {}

	cQuery := " SELECT R_E_C_N_O_ AS REGISTRO FROM ZPR010 WHERE D_E_L_E_T_ = '' "
	cQuery += " AND ZPR_FILIAL =	 '' "
	cQuery += " AND ZPR_GRUPO  =	 '"+cGRUPO +"' "
	cQuery += " AND ZPR_CHAVE  =	 '"+cCHAVE +"' "
	cQuery += " ORDER BY ZPR_GRUPO, ZPR_CHAVE "

	::RunQuery(cQuery,_cTrb,.F.)

	While (_cTrb)->(!Eof())
		aadd(_aRet,::getByRecno((_cTrb)->REGISTRO))
		(_cTrb)->(dbSkip())
	End

	(_cTrb)->(dbCloseArea())

Return _aRet

/*---------------------------------------------------------------------*
 | Method: chvToIn                                                     |
 *---------------------------------------------------------------------*/
Method chvToIn(_cGrupo,_cTipo) Class TCadGen

	Local cQuery
	Local _cRetorno := ""
	Local _cTrb     := GetNextAlias()

	_cTipo := If(!Empty(_cTipo),_cTipo,"B") 

	cQuery := " SELECT 	ZPR_CHAVE " 
	cQuery += " FROM 	ZPR010  " 
	cQuery += " WHERE 	ZPR_FILIAL = ''  " 
	cQuery += " AND 	ZPR_GRUPO = '"+_cGrupo+"'  " 
	cQuery += " AND 	D_E_L_E_T_ = '' "
	cQuery += " ORDER BY ZPR_GRUPO, ZPR_CHAVE "

	::RunQuery(cQuery,_cTrb,.F.)

	While (_cTrb)->(!Eof())
		_cRetorno += Alltrim((_cTrb)->ZPR_CHAVE)+"|"
		(_cTrb)->(dbSkip())
	End

	If !Empty(_cRetorno)

		_cRetorno := Left(_cRetorno,Len(_cRetorno)-1)

		If _cTipo == "B" // banco de dados
			_cRetorno := "'"+StrTran(_cRetorno,"|","','")+"'"
		Endif

	Endif

	(_cTrb)->(dbCloseArea())

Return(_cRetorno)	


/*---------------------------------------------------------------------*
 | Method: getTabelaGenerica                                           |
 *---------------------------------------------------------------------*/
Method getTabelaGenerica(_cGrupo,_cChave) Class TCadGen

	Local _cRetorno := ""

	dbSelectArea("ZPR")
	ZPR->(dbSetOrder(1))
	If ZPR->(dbSeek(xFilial("ZPR")+Padr(_cGrupo,10)+Padr(_cChave,10)))
		_cRetorno := Alltrim(ZPR->ZPR_GENERI)
	Endif

Return(_cRetorno)

/*---------------------------------------------------------------------*
 | Method: getChave                                                    |
 *---------------------------------------------------------------------*/
Method getChave(_cGrupo,_cGeneri) Class TCadGen

	Local cQuery
	Local _cRetorno := ""
	Local _cTrb     := GetNextAlias()

	cQuery := " SELECT ZPR_CHAVE  " 
	cQuery += " FROM   ZPR010  " 
	cQuery += " WHERE  ZPR_FILIAL = ''  " 
	cQuery += " AND    ZPR_GRUPO		= '"+_cGrupo+"'  " 
	cQuery += " AND    ZPR_GENERI = '"+_cGeneri+"'  " 
	cQuery += " AND    D_E_L_E_T_ = '' "

	If ::RunQuery(cQuery,_cTrb,.t.) > 0
		_cRetorno := alltrim((_cTrb)->ZPR_CHAVE)
	Endif

	(_cTrb)->(dbCloseArea())

Return(_cRetorno)	

/*---------------------------------------------------------------------*
 | Method: nextChaveGrupo                                              |
 *---------------------------------------------------------------------*/
Method nextChaveGrupo(_cGrupo) Class TCadGen

	Local cQuery
	Local _cTrb     := GetNextAlias()

	cQuery := " SELECT ISNULL(MAX(ZPR_CHAVE), 'NA') AS CHV  " 
	cQuery += " FROM   ZPR010  " 
	cQuery += " WHERE  ZPR_FILIAL = ''  " 
	cQuery += " AND    ZPR_GRUPO		= '"+_cGrupo+"'  " 
	cQuery += " AND    D_E_L_E_T_ = '' "

	::RunQuery(cQuery,_cTrb,.f.)

	If Alltrim((_cTrb)->CHV) != "NA"
		_nChave := Val(Alltrim((_cTrb)->CHV))
		If _nChave == 0
			return -1 // Avisando que a chave usada para essa tabela ZPR nao eh um numerico com isso nao tera como usar esse metodo
		Else
			return StrZero(_nChave+1,10)
		EndIf
	Else
		return StrZero(1,10)
	Endif

	(_cTrb)->(dbCloseArea())

Return

/*---------------------------------------------------------------------*
 | Method: validaGrupoChave                                            |
 *---------------------------------------------------------------------*/
Method validaGrupoChave(_cGrupo,_cChave) Class TCadGen

	Local _lRetorno := .f.

	dbSelectArea("ZPR")
	ZPR->(dbSetOrder(1))
	If ZPR->(dbSeek(xFilial("ZPR")+Padr(_cGrupo,10)+Padr(_cChave,10)))
		_lRetorno := .t.
	Endif

Return(_lRetorno)