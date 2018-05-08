#include "FiveWin.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#include "Fileio.ch"
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Cliente   ³            ³                                                 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Programa  ³ TUtil      ³ Autor ³ ISMAEL VALDIR         ³ Data ³ 27/04/11 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descricao ³ Cria um objeto para tratamentos diversos                     ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
User Function TUtil();Return
	
Class TUtil
	
	Method new() CONSTRUCTOR
	Method arrayToString()
	Method stringToArray()
	Method getColunaArray()
	Method expExcel()
	Method aleatorio()
	Method executaQuery()
	Method IndiceEquivalente()
	Method CalculoFinanciamento()
	Method CalculoIRTabelaRH()
	Method CalculoInssTabelaRH()
	Method ValorTabelaSRX()
	Method gerarSequenciaAlfa()
	Method objectToXml()
	Method validaChvDanfe()
	Method getMemoToArray()
	Method registraAnaliseUso()
	Method registraWS()
	Method logFechaEstoque()
	Method ctlFechaEstoque()
	Method verFctoEstoque()
	Method sqlScript()
	Method noAcento()
	Method LocTagXML()
	
	
EndClass

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ new                                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method New() Class TUtil
Return Self

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ArrayToString                                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method ArrayToString(_aArray,_cSeparador) Class TUtil
	
	
	Local 	_cRetorno 	:= ""
	Local 	_cVar     	:= ""
	Local	 	x
	Local 	_nTamArr  	:= Len(_aArray)
	Local 	_cValor   	:= ""
	
	_cSeparador 	:= If(_cSeparador!=Nil,_cSeparador,"")
	
	For x:=1 To _nTamArr
		
		If ValType(_aArray[x]) == "C"
			_cValor := _aArray[x]
		ElseIf ValType(_aArray[x]) == "D"
			_cValor := Dtoc(_aArray[x])
		ElseIf ValType(_aArray[x]) == "N"
			_cValor := StrTran(Alltrim(Str(_aArray[x],30,10)),".",",")
		ElseIf ValType(_aArray[x]) == "A"
			_cValor := "ERRO - TIPO EH UM ARRAY"
		ElseIf ValType(_aArray[x]) == "B"
			_cValor := "ERRO - TIPO EH UM BLOCO DE CODIGO"
		ElseIf ValType(_aArray[x]) == "L"
			_cValor := "ERRO - TIPO EH UM LOGICO"
		ElseIf ValType(_aArray[x]) == "O"
			_cValor := "ERRO - TIPO EH UM OBJETO"
		Else
			_cValor	:= "ERRO - TIPO NAO IDENTIFICADO"
		Endif
		_cRetorno := _cRetorno+_cValor+If(_nTamArr<>x,_cSeparador,"")
	Next x
	
Return(_cRetorno)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ StringToArray                                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method StringToArray(_cString,_cSeparador) Class TUtil
	
	Local _aArray := {}
	Local _cTxt   := ""
	Local _cChar  := ""
	Local x
	
	For x:=1 To Len(_cString)
		_cChar := SubStr(_cString,x,1)
		If _cChar != _cSeparador
			_cTxt += _cChar
		Else
			aadd(_aArray,_cTxt)
			_cTxt := ""
		Endif
	Next x
	aadd(_aArray,_cTxt)
	
Return(_aArray)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ getColunaArray                                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method getColunaArray(_cString,_aArray) Class TUtil
	
	Local _nColuna	:= 0
	Local xnP     	:= 0
	
	//processa o array para saber qual a coluna
	For xnP:=1 to len(_aArray)
		If Trim(_aArray[xnP][2]) == _cString
			_nColuna	:= xnP
			xnP 			:= len(_aArray)
		Endif
	Next xnP
	
Return(_nColuna)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ExpExcel                                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method ExpExcel(_aArray,_cDestino, _aCabec) Class TUtil
	
	Local _nHandle := MSFCREATE(_cDestino)
	Local _nTamArr  := Len(_aArray)
	Local x
	
	ProcRegua(_nTamArr)
	
	If _aCabec <> nil
		_cLinha := ::arrayToString(_aCabec[1],";")+Chr(13)+Chr(10)
		FWrite(_nHandle,_cLinha,Len(_cLinha))
	Endif
	
	For x:=1 To _nTamArr
		IncProc("Gerando registro "+Str(x))
		_cLinha := ::arrayToString(_aArray[x],";")+Chr(13)+Chr(10)
		FWrite(_nHandle,_cLinha,Len(_cLinha))
	Next x
	
	FClose(_nHandle)
	
	MsgInfo("Arquivo "+_cDestino+", gerado com sucesso!")
	
Return()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Aleatorio                                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method Aleatorio(_nQuantidade) Class TUtil
	
	Local  	i     	:= 0
	Private _nSeed := Seconds()
	Private _cRet  := ""
	
	Private _aChar := {"0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f","g","h","i","j","k",;
		"l","m","n","o","p","q","r","s","t","u","v","x","w","y","z","A","B","C","D","E","F",;
		"G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","X","W","Y","Z"}
	
	
	For i:= 1 To _nQuantidade
		_nSeed := Aleatorio(61,_nSeed)+1
		_cRet += _aChar[_nSeed]
	Next i
	
Return(_cRet)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ExecutaQuery                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method ExecutaQuery(_cQuery,_cAlias,_lReturn,_cIdent,_lExpQuery) Class TUtil
	
	Local _nRet     := 0
	Local _nTimeIni := Seconds()
	Local _nTimeFim := 0
	
	If Empty(_cAlias)
		_cAlias := GetNextAlias()
	Endif
	
	_lReturn   := If(_lReturn  !=Nil,_lReturn  ,.F.)
	_lExpQuery := If(_lExpQuery!=Nil,_lExpQuery,.F.)
	
	If Upper(Substr(LTrim(_cQuery),1,6)) == "SELECT"
		
		If !Empty(Select(_cAlias))
			dbSelectArea(_cAlias)
			dbCloseArea()
		Endif
		TCQuery _cQuery NEW ALIAS &_cAlias
		dbSelectArea(_cAlias)
		
		// verifico se deseja retornar o numero de registros
		If _lReturn
			Count To _nRet
		Endif
		(_cAlias)->(dbGoTop())
		
	Else
		_nRet := TCSQLEXEC(_cQuery)
		If _nRet != 0
			ConOut("Falha de Execucao ("+Str(_nRet,4)+") : "+TcSqlError())
		Endif
	Endif
	
	_nTimeFim := Seconds()

	// fazendo controle de qualidade de querys
	If SuperGetMv("PR_LOGAQRY",.F.,.T.)
		If _cIdent != Nil
			TCSQLEXEC("INSERT INTO ANALISE_QUERY (IDENTIFICACAO,DATA,HORA,QUERY,TEMPO) VALUES ('"+_cIdent+"','"+dtos(MsDate())+"','"+Time()+"','"+StrTran (_cQuery,"'","#")+"',"+Str(_nTimeFim-_nTimeIni)+")")
		Endif
	Endif

	/*
	CREATE TABLE [dbo].[ANALISE_QUERY](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IDENTIFICACAO] [varchar](20) NULL,
	[DATA] [varchar](8) NULL,
	[HORA] [varchar](8) NULL,
	[QUERY] [image] NULL,
	[TEMPO] [float] NULL,
	PRIMARY KEY CLUSTERED 
	(
	[ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
	*/

	If _lExpQuery
		If _cIdent != Nil
			U_SIDGERATXT(_cQuery,"c:\temp\"+_cIdent+".txt")
		Else
			U_SIDGERATXT(_cQuery,"c:\temp\testeQuery.txt")
		Endif
	Endif
	
Return(_nRet)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ IndiceEquivalente                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method IndiceEquivalente(_nInd,_nPer) Class TUtil
	
Return((((1 + (_nInd/100)) ^ _nPer)-1)*100)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CalculoFinanciamento                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method CalculoFinanciamento(_cRet,_i,_n,_P,_R) Class TUtil
	
	Private _nRet := 0
	
	_i := If(_i!=Nil,_i/100,0)
	_n := If(_n!=Nil,_n,1)
	_P := If(_P!=Nil,_P,0)
	_R := If(_R!=Nil,_R,0)
	
	If _cRet == "PMT"
		_nRet := _P*((_i*((1+_i)^_n))/(((1+_i)^_n)-1))
	Endif
	
	If _cRet == "PMTCE"
		_nRet := _P*(1/(1+_i)) * ((_i*((1+_i)^_n)) / (((1+_i)^_n)-1))
	Endif
	
	If _cRet == "FV"
		_nRet := _P*((1+_i)^_n)
	Endif
	
	
Return(_nRet)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CalculoIRTabelaRH                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method CalculoIRTabelaRH(_nVlBaseIr,cCompet) Class TUtil
	
	Local _nVLIR		:= 0
	Local _nIsento := ::ValorTabelaSRX("09",cCompet,"X09_REND1")
	Local _nRend2  := ::ValorTabelaSRX("09",cCompet,"X09_REND2")
	Local _nAliq2  := ::ValorTabelaSRX("09",cCompet,"X09_ALIQ2")
	Local _nDesc2  := ::ValorTabelaSRX("09",cCompet,"X09_PARC2")
	Local _nRend3  := ::ValorTabelaSRX("09",cCompet,"X09_REND3")
	Local _nAliq3  := ::ValorTabelaSRX("09",cCompet,"X09_ALIQ3")
	Local _nDesc3  := ::ValorTabelaSRX("09",cCompet,"X09_PARC3")
	Local _nRend4  := ::ValorTabelaSRX("09",cCompet,"X09_REND4")
	Local _nAliq4  := ::ValorTabelaSRX("09",cCompet,"X09_ALIQ4")
	Local _nDesc4  := ::ValorTabelaSRX("09",cCompet,"X09_PARC4")
	Local _nRend5  := ::ValorTabelaSRX("09",cCompet,"X09_REND5")
	Local _nAliq5  := ::ValorTabelaSRX("09",cCompet,"X09_ALIQ5")
	Local _nDesc5  := ::ValorTabelaSRX("09",cCompet,"X09_PARC5")
	
	If _nVlBaseIr <= _nIsento
		_nVLIR := 0
	ElseIf (_nVlBaseIr <= _nRend2)
		_nVLIR := (_nVlBaseIr * (_nAliq2/100)) - _nDesc2
	ElseIf (_nVlBaseIr <= _nRend3)
		_nVLIR := (_nVlBaseIr * (_nAliq3/100)) - _nDesc3
	ElseIf (_nVlBaseIr <= _nRend4)
		_nVLIR := (_nVlBaseIr * (_nAliq4/100)) - _nDesc4
	Else
		_nVLIR := (_nVlBaseIr * (_nAliq5/100)) - _nDesc5
	Endif
	
Return(_nVLIR)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ CalculoIRTabelaRH                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method CalculoInssTabelaRH(_nVlBaseInss,cCompet) Class TUtil
	
	Local _nVLInss := 0
	Local _nLInss4 := ::ValorTabelaSRX("08",cCompet,"X08_LIM4")
	Local _nPerc4  := ((::ValorTabelaSRX("08",cCompet,"X08_PERC4"))/100)
	Local _nLInss3 := ::ValorTabelaSRX("08",cCompet,"X08_LIM3")
	Local _nPerc3  := ((::ValorTabelaSRX("08",cCompet,"X08_PERC3"))/100)
	Local _nLInss2 := ::ValorTabelaSRX("08",cCompet,"X08_LIM2")
	Local _nPerc2  := ((::ValorTabelaSRX("08",cCompet,"X08_PERC2"))/100)
	Local _nLInss1 := ::ValorTabelaSRX("08",cCompet,"X08_LIM1")
	Local _nPerc1  := ((::ValorTabelaSRX("08",cCompet,"X08_PERC1"))/100)
	Local _nValCal := 0
	local _nAliq   := 0
	
	//se tem limite 4 e base maior igual a 4 usa limite e aliquota 4
	If _nLInss4 > 0 .and. _nVlBaseInss >= _nLInss4
		_nValCal	:= _nLInss4
		_nAliq		:= _nPerc4
	Else
		//se tem limite 3 e base maior igual a 3 usa limite e aliquota 3
		If _nLInss3 > 0 .and. _nVlBaseInss >= _nLInss3
			_nValCal	:= _nLInss3
			_nAliq		:= _nPerc3
			//se tem limite 3  e esta na faixa 3 usa base passada e limite 3
		ElseIf _nLInss3 > 0 .and. (_nVlBaseInss < _nLInss3 .and. 	_nVlBaseInss > _nLInss2)
			_nValCal	:= _nVlBaseInss
			_nAliq		:= _nPerc3
		Else
			//se tem limite 2 e base maior igual a 2 usa limite e aliquota 2
			If _nLInss2 > 0 .and. _nVlBaseInss >= _nLInss2
				_nValCal	:= _nLInss2
				_nAliq		:= _nPerc2
				//se tem limite 2  e esta na faixa 2 usa base passada e limite 2
			ElseIf _nLInss2 > 0 .and. (_nVlBaseInss < _nLInss2 .and. 	_nVlBaseInss > _nLInss1)
				_nValCal	:= _nVlBaseInss
				_nAliq		:= _nPerc2
			Else
				//se tem limite 1 e base maior igual a 1 usa limite e aliquota 1
				If _nLInss1 > 0 .and. _nVlBaseInss >= _nLInss1
					_nValCal	:= _nLInss1
					_nAliq		:= _nPerc1
					//se tem limite 1  e esta na faixa 1 usa base passada e limite 1
				ElseIf _nLInss1 > 0 .and. (_nVlBaseInss < _nLInss1 .and. 	_nVlBaseInss > 0)
					_nValCal	:= _nVlBaseInss
					_nAliq		:= _nPerc1
				Endif
			Endif
		Endif
	Endif
	
	//calcula inss
	_nVLInss := (_nValCal * _nAliq)
	
	
Return(_nVLInss)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ValorTabelaSRX                                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method ValorTabelaSRX(cTabela,cChave,cCampo) Class TUtil
	
	Local _nVlRet := 0
	
	cQuery := " SELECT R5_REG, R5_DEONDE, R5_DE, R5_QUANTOS, (SELECT COUNT(*) "
	cQuery += " 										FROM SIGAGPE GPE2 "
	cQuery += " 										WHERE GPE2.R5_FILIAL = '' "
	cQuery += " 										AND   GPE2.R5_ARQUIVO = '"+"X"+cTabela+"' "
	cQuery += " 										AND   GPE2.R5_DEONDE = 'RX_CODCHAVE' "
	cQuery += " 										AND   GPE2.R5_REG > '01' "
	cQuery += " 										AND   GPE2.D_E_L_E_T_ = '') AS QTDREG "
	cQuery += " FROM   SIGAGPE "
	cQuery += " WHERE  R5_ARQUIVO = '"+"X"+cTabela+"' "
	cQuery += " AND    R5_CAMPO = '"+cCampo+"' "
	
	If (::executaQuery(cQuery,"TRGPE",.t.)) > 0
		While TRGPE->(!Eof())
			
			cQuery := " SELECT SUBSTRING("+TRGPE->R5_DEONDE+","+Alltrim(Str(TRGPE->R5_DE))+","+Alltrim(Str(TRGPE->R5_QUANTOS))+") AS VLRET "
			cQuery += " FROM   "+RetSqlName("SRX")+"  "
			cQuery += " WHERE  RX_TIP = '"+cTabela+"' "
			cQuery += " AND    D_E_L_E_T_ = '' "
			If TRGPE->QTDREG > 0
				cQuery += " AND    RX_COD = '"+cChave+Alltrim(Str(Val(TRGPE->R5_REG)))+"' "
			Else
				cQuery += " AND    LTRIM(RX_COD) = '"+Alltrim(cChave)+"' "
			Endif
			
			TRGPE->(dbSkip())
		End
		
		If (::executaQuery(cQuery,"TRSRX",.t.)) > 0
			_nVlRet := Val(TRSRX->VLRET)
		Endif
	Endif
	
Return(_nVlRet)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ gerarSequenciaAlfa                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method gerarSequenciaAlfa(_nPos) Class TUtil
	
	Private _aPos := {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","X","Y","W","Z"}
	Private _nTam := Len(_aPos)
	Private _a := Int(_nPos/_nTam)
	Private _b
	
	If _nPos % _nTam == 0
		_b := Round((((_nPos / _nTam)-(_a-1))*_nTam),0)
	Else
		_b := Round((((_nPos / _nTam)-_a)*_nTam),0)
		_a++
	Endif
	
Return(_aPos[_a]+_aPos[_b])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ objectToXml                                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method objectToXml(_oObj,_cFormatData,_aSingle) Class TUtil
	
	Local _aAtb
	Local _cXml   := ""
	Local x
	Local y
	Local _cTag
	Local _cTipo
	Local _oData  := TData():New()
	Local _nAscan := 0
	
	If Empty(_aSingle)
		_aSingle := {{"",""}}
	Endif
	
	If ValType(_oObj) != "O"
		conout("Variavel nao é um objeto")
		Return("-1")
	Endif
	
	_aAtb := ClassDataArr(_oObj)
	
	If Len(_aAtb) <= 0
		conout("Objeto nao possui atributos")
		Return("-2")
	Endif
	
	For x:=1 To Len(_aAtb)
		
		_cTag   := Alltrim(_aAtb[x,1])
		_cTipo  := ValType(_aAtb[x,2])
		
		If _aAtb[x,2] == Nil
			_cXml += "<"+_cTag+"></"+_cTag+">"
		ElseIf _cTipo == "C"
			_cXml += "<"+_cTag+">"+Alltrim(_aAtb[x,2])+"</"+_cTag+">"
		ElseIf _cTipo == "N"
			_cXml += "<"+_cTag+">"+Alltrim(Str(_aAtb[x,2]))+"</"+_cTag+">"
		ElseIf _cTipo == "D"
			If Empty(_cFormatData)
				_cXml += "<"+_cTag+">"+dtos(_aAtb[x,2])+"</"+_cTag+">"
			Else
				_oData:setData(_aAtb[x,2])
				_cXml += "<"+_cTag+">"+_oData:getDataFormatada(_cFormatData)+"</"+_cTag+">"
			Endif
		ElseIf _cTipo =="L"
			_cXml += "<"+_cTag+">"+If(_aAtb[x,2],"TRUE","FALSE")+"</"+_cTag+">"
		ElseIf _cTipo =="O"
			_cXml += "<"+_cTag+">"+::objectToXml(_aAtb[x,2],_cFormatData,_aSingle)+"</"+_cTag+">"
		ElseIf _cTipo =="A"
			_cXml += "<"+_cTag+">"
			For y:=1 To Len(_aAtb[x,2])
				
				_nAscan :=  Ascan(_aSingle,{|x| x[1] == _cTag})
				If _nAscan > 0
					_cXml += "<"+_aSingle[_nAscan,2]+">"
				Else
					_cXml += "<"+Substr(_cTag,1,Len(_cTag)-1)+">"
				Endif
				
				_cXml += ::objectToXml(_aAtb[x,2,y],_cFormatData,_aSingle)
				
				If _nAscan > 0
					_cXml += "</"+_aSingle[_nAscan,2]+">"
				Else
					_cXml += "</"+Substr(_cTag,1,Len(_cTag)-1)+">"
				Endif
				
			Next y
			
			_cXml += "</"+_cTag+">"
			
		Endif
		
	Next x
	
Return(_cXml)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ validaChvDanfe                                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method validaChvDanfe(_cChave) Class TUtil
	
	Local _cDvOriginal   := Substr(_cChave,44,1)
	Local _cDvCalculado 	:= ""
	Local _cChave  := Substr(_cChave,1,43)
	
	Local _nPeso1  	:= 2
	Local _nPeso2  	:= 9
	Local _nTot   	:= 0
	Local _nMul 		:= _nPeso1
	Local i
	
	for i := Len(_cChave) to 1 step -1
		_nTot += Val(SubStr(_cChave,i,1)) * _nMul
		_nMul := if(_nMul == _nPeso2, _nPeso1, _nMul + 1)
	next
	
	_cDvCalculado    = If(_nTot%11 < 2, "0", StrZero(11-(_nTot%11),1))
	
Return ( If(_cDvOriginal!=_cDvCalculado,.f.,.t.) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ getMemoToArray                                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method getMemoToArray(_cString,_nTamLinha) Class TUtil
	
	Local x
	Local _aRet    := {}
	Local _cLinha  := ""
	Local _nCont   := 0
	
	For x:=1 To Len(_cString)
		_cChar := Substr(_cString,x,1)
		
		If _cChar == CHR(10)
			aadd(_aRet,_cLinha)
			_cLinha := ""
			_nCont 	:= 0
		Else
			If _nCont == _nTamLinha
				aadd(_aRet,_cLinha)
				_cLinha := _cChar
				_nCont 	:= 1
			Else
				_cLinha += _cChar
				_nCont++
			Endif
		Endif
	Next x
	
	If !Empty(_cLinha)
		aadd(_aRet,_cLinha)
	Endif
	
Return _aRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ registraAnaliseUso                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method registraAnaliseUso(_cFuncao) Class TUtil
	
	Local _cFunName := FunName()
	
	If SuperGetMv("PR_LOGAUSO",.F.,.T.)
		
		If Type("__cUserId") == "U"
			__cUserId := "000001"
		Endif
		If Type("cArqMnu") == "U"
			cArqMnu := ""
		Endif
		If Type("cModulo") == "U"
			cModulo := ""
		Endif
		
		TCSpExec("SP_ANALISE_USO_CRIAR",If(_cFuncao!=Nil,_cFuncao,_cFunName),__cUserId,cArqMnu,cModulo,_cFunName)
		
		/*
		CREATE TABLE [dbo].[ANALISE_USO](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[FUNCAO] [char](30) NULL,
		[DATA] [char](8) NULL,
		[HORA] [char](8) NULL,
		[USUARIO] [char](20) NULL,
		[ARQMENU] [char](100) NULL,
		[MODULO] [char](12) NULL,
		[FUNMENU] [char](30) NULL,
		PRIMARY KEY CLUSTERED 
		(
		[ID] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
		) ON [PRIMARY]
		*/
	Endif
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ registraWS                                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method registraWS(_cServico,_cMetodo,_cSessao,_cConteudo) Class TUtil
	
	If SuperGetMv("PR_LOGAWS",.F.,.T.)
		
		_cConteudo := StrTran(StrTran(StrTran(_cConteudo,'"',"#||#"),"#|#","#"),"'","#|||#")
		
		TCSQLEXEC("INSERT INTO ANALISE_WS (SERVICO,METODO,SESSAO,DATA,HORA,CONTEUDO_ENTRADA) VALUES ('"+_cServico+"','"+_cMetodo+"','"+_cSessao+"','"+dtos(MsDate())+"','"+Time()+"','"+_cConteudo+"')")
		
		/*
		CREATE TABLE [dbo].[ANALISE_WS](
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[SERVICO] [varchar](20) NULL,
		[METODO] [varchar](30) NULL,
		[DATA] [varchar](8) NULL,
		[HORA] [varchar](8) NULL,
		[CONTEUDO_ENTRADA] [image] NULL,
		[SESSAO] [char](8) NULL,
		PRIMARY KEY CLUSTERED 
		(
		[ID] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
		*/
	Endif
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ logFechaEstoque                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method logFechaEstoque(_cRotina,_cTipo,_cEvento) Class TUtil
	
	TCSQLEXEC("INSERT INTO ANALISE_FECHAMENTO_ESTOQUE (FILIAL,DATA,HORA,ROTINA,TIPO,EVENTO) VALUES ('"+xFilial("SF2")+"','"+dtos(MsDate())+"','"+Time()+"','"+_cRotina+"','"+_cTipo+"','"+_cEvento+"')")
	
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ctlFechaEstoque                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method ctlFechaEstoque(_dDataCtrl, _cRotina) Class TUtil
	
	TCSQLEXEC("INSERT INTO CONTROLE_FECHAMENTO_ESTOQUE (FILIAL,DATA,HORA,DTFIM,ROTINA) VALUES ('"+xFilial("SF2")+"','"+dtos(MsDate())+"','"+Time()+"','"+dtos(_dDataCtrl)+"','"+_cRotina+"')")
	
Return
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ verFctoEstoque                                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method verFctoEstoque(_dDataCtrl, _cRotina) Class TUtil 
	
	_cQry := " SELECT   TOP 1 DTFIM "
	_cQry += " FROM     CONTROLE_FECHAMENTO_ESTOQUE " 
	_cQry += " WHERE    FILIAL = '"+ xFilial("SF2") +"' " 
	_cQry += " AND      DTFIM  = '"+ dtos(_dDataCtrl) +"' " 
	_cQry += " AND      ROTINA = '"+ _cRotina +"' "
	_cQry += " ORDER BY ID DESC  "
	
	If (::executaQuery(_cQry,"TCTRL",.t.)) == 1 
		Return .T.
	Endif
	
Return .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ sqlScript                                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Method sqlScript(_cProcesso) Class TUtil
	
	Local x
	
	Default _cProcesso 	:= ""
	
	//VERIFICA SE ESTA RODANDO VIA MENU OU SCHEDULE
	If Select("SX6") == 0
		_lJob := .T.
		RpcSetType(3)
		RpcSetEnv("01","01")
	EndIf
	
	Private _lJob 				:= .F.
	Private _aFile    			:= {}
	Private _cStartPath		:= "\SIGAADV\sqlscript\"
	Private _cString			:= ""
	Private _cFile				:= ""
	Private _nHandle       := 0
	
	// cria o diretorio caso ainda nao exista
	MakeDir(_cStartPath)
	
	conout(" ")
	conout("================================================")
	conout("Iniciado SOFSCRIPT")
	conout(">>> Data: "+dtoc(MsDate())+" - Hora: "+Time())
	conout(">>> _cProcesso = "+_cProcesso)
	conout("================================================")
	conout(" ")
	
	If Empty(_cProcesso)
		
		_aFile := Directory(_cStartPath+"*.sql",,,.t.)
		
	Else
		
		_aFile := Directory(_cStartPath+_cProcesso+"*.sql",,,.t.)
		
	Endif
	
	ConOut("SOFSCRIPT - Numero de arquivos localizados "+Alltrim(Str(Len(_aFile))))
	
	For x:=1 To Len(_aFile)
		
		_cFile := _cStartPath+_aFile[x,1]
		
		If File(_cFile)
			_nHandle := fopen(_cFile, FO_READWRITE + FO_SHARED )
			
			_cString := ""
			FRead(_nHandle,_cString,8000)
			
			_nRet := TCSQLEXEC(_cString)
			If _nRet != 0
				ConOut("SOFSCRIPT - "+_cFile)
				ConOut("SOFSCRIPT - Falha de Execucao ("+Str(_nRet,4)+") : "+TcSqlError())
			Endif
			
		Else
			conout("SOFSCRIPT - Arquivo nao localizado - "+_cFile)
		Endif
		
	Next x
	
	conout(" ")
	conout("================================================")
	conout("Finalizado SOFSCRIPT")
	conout(">>> Data: "+dtoc(MsDate())+" - Hora: "+Time())
	conout("================================================")
	conout(" ")
	
Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³METHOD          ³NoAcento                                              ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Method noAcento(cString)  Class TUtil
	
	Local cChar  := ""
	Local nX     := 0
	Local nY     := 0
	Local cVogal := "aeiouAEIOU"
	Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
	Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
	Local cTrema := "äëïöü"+"ÄËÏÖÜ"
	Local cCrase := "àèìòù"+"ÀÈÌÒÙ"
	Local cTio   := "ãõÃÕ"
	Local cCecid := "çÇ"
	Local cMaior := "&lt;"
	Local cMenor := "&gt;"
	
	For nX:= 1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)
		IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
			nY:= At(cChar,cAgudo)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCircu)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTrema)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCrase)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTio)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("aoAO",nY,1))
			EndIf
			nY:= At(cChar,cCecid)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("cC",nY,1))
			EndIf
		Endif
	Next
	
	If cMaior$ cString
		cString := strTran( cString, cMaior, "" )
	EndIf
	If cMenor$ cString
		cString := strTran( cString, cMenor, "" )
	EndIf
	
	For nX:=1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)
		If (Asc(cChar) < 32 .Or. Asc(cChar) > 123) .and. !cChar $ '|'
			cString:=StrTran(cString,cChar,".")
		Endif
	Next nX
	
	cString:=StrTran(cString, "&"     	, "E")
	cString:=StrTran(cString, "ª"     	, "a")
	cString:=StrTran(cString, "º"     	, "a")
	
	cString := Alltrim(EncodeUTF8(_NoTags(cString)))
	
Return cString
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³METHOD          ³ LocTagXML                                            ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Method LocTagXml(_xXmlBase,_xTagBuscar,_xTagInf)  Class TUtil

	Local _cTagBuscar := _xTagBuscar
	Local _cTagInf 		:= _xTagInf
	Local _cTotTagInf	:= "_oTmpXml:_"+_xTagInf
	Local _oXmlBase 	:= _xXmlBase
	Local _x					:= 0
	Local _lFound  		:= .F.
	Local _oRetXML		:= Nil
	Local _oTmp2Xml  	:= Nil
	Private _oTmpXml    := Nil


	_oRetXML := XmlChildEx(_oXmlBase,"_"+_cTagBuscar)

	If _oRetXML != Nil .and. !Empty(_cTagInf)
		_oTmpXml := _oRetXML
		If Type(_cTotTagInf) == "U"
			_oRetXML := Nil
		Endif
	Endif

	If _oRetXML == Nil
		For _x := 1 To XmlChildCount(_oXmlBase)

			_oTmp2Xml := XmlGetchild(_oXmlBase,_x)

			If ValType(_oTmp2Xml) == "O" .and. XmlChildCount(_oTmp2Xml) > 0

				_oRetXML := ::LocTagXml(_oTmp2Xml,_cTagBuscar,_cTagInf)

				If _oRetXML !=  Nil
					Exit
				Endif

			Endif

		Next _x
	Endif

Return(_oRetXML)