#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FONT.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} TCSS
Função para dar estilo aos componentes visuais
@author Leonardo Gregorio de Almeida
@since 07/05/2018
@return Nil, Função não tem retorno
/*/
User Function TCSS(); Return()

/*---------------------------------------------------------------------*
 | Class: TCSS                                                         |
 *---------------------------------------------------------------------*/
Class TCSS

	// metodos
	Method New() CONSTRUCTOR
	Method QPushButton()

EndClass

/*---------------------------------------------------------------------*
 | Method: New                                                         |
 *---------------------------------------------------------------------*/
Method New() Class TCSS
Return Self

/*---------------------------------------------------------------------*
 | Method: QPushButton                                                 |
 *---------------------------------------------------------------------*/
Method QPushButton(cIcon) Class TCSS

	cEstilo := "QPushButton {"
	cEstilo += " border-style: outset;"
	cEstilo += " border-width: 2px;"
	cEstilo += " border: 1px solid #C0C0C0;"
	cEstilo += " border-radius: 5px;"
	cEstilo += " border-color: #C0C0C0;"
	cEstilo += " font: bold 12px Arial;"
	cEstilo += " padding: 6px;"
	If !Empty(cIcon)
		cEstilo += " background-image: url(rpo:"+ cIcon +");background-repeat: none; margin: 2px;"
	Endif
	cEstilo += " background-color: qradialgradient(cx: 0.5, cy: 0.5, radius: 2, fx: 0.5, fy: 1, stop: 0 rgba(127,157,183,255), stop: 0.2 rgba(127,157,183,144), stop: 0.4 rgba(127,157,183,32));
	cEstilo += "}"
	cEstilo += "QPushButton:pressed {"
	cEstilo += " background-color: #E6E6F9;"
	cEstilo += " border-style: inset;"
	cEstilo += "}"

Return(cEstilo)
