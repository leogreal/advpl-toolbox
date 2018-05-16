#INCLUDE "FIVEWIN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FILEIO.CH"

/*/{Protheus.doc} TSQL
Fun��o para manipula��o BD
@author Leonardo Gregorio de Almeida
@since 16/05/2018
@return Nil, Fun��o n�o tem retorno
/*/
User Function TSQL();Return
	
Class TSQL
	
	Method new() CONSTRUCTOR
	Method RunQuery()
	
EndClass

//���������������������������������������������������������������������������Ŀ
//� new                                                                       �
//�����������������������������������������������������������������������������
Method New() Class TSQL
Return Self

//���������������������������������������������������������������������������Ŀ
//� ExecutaQuery                                                              �
//�����������������������������������������������������������������������������
Method RunQuery(cQuery,cAliasTB,lReturn,cIdent) Class TSQL
	
	Local _nRet     := 0
	Local _nTimeIni := Seconds()
	Local _nTimeFim := 0
	
	If Empty(cAliasTB)
		cAliasTB := GetNextAlias()
	Endif
	
	lReturn   := If(lReturn  !=Nil,lReturn  ,.F.)
	
	If Upper(Substr(LTrim(cQuery),1,6)) == "SELECT"
		
		If !Empty(Select(cAliasTB))
			dbSelectArea(cAliasTB)
			dbCloseArea()
		Endif
		TCQuery cQuery NEW ALIAS &cAliasTB
		dbSelectArea(cAliasTB)
		
		// verifico se deseja retornar o numero de registros
		If lReturn
			Count To _nRet
		Endif
		(cAliasTB)->(dbGoTop())
		
	Else
		_nRet := TCSQLEXEC(cQuery)
		If _nRet != 0
			ConOut("Falha de Execucao ("+Str(_nRet,4)+") : "+TcSqlError())
		Endif
	Endif
	
	_nTimeFim := Seconds()

Return(_nRet)