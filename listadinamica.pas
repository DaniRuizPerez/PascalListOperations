UNIT listadinamica;
(*Prácticas de PROGRAMACION II
Practica 1
AUTOR 1: Ruiz Pérez Daniel LOGIN 1: d.ruiz.perez
AUTOR 2: Barbeito Vázquez Ismael LOGIN 2: i.barbeito
GRUPO: 2.3.2
FECHA: 30/03/2012*)
INTERFACE

CONST	
	NULO = nil;
	MAXREP = 3;

Type
	tNickUsuario = string;
	tTipoUsuario = (normal,premium);
	tNumReproducciones = integer;
	TDato = RECORD
		nickUsuario: tNickUsuario;
		numReproducciones: tNumReproducciones;
		tipoUsuario: tTipoUsuario;
	END;
	TTitulo = string; 
	TCancion = RECORD
		titulo: tTitulo;
	END;
	tPosL = ^tNodo; 
	TNodo = RECORD
		Datos: TDato;
		Siguiente: tPosL;
	END;
	tListaOrdenada = tPosL;

FUNCTION ListaVacia: tListaOrdenada;
FUNCTION esListaVacia (lista: tListaOrdenada): boolean;
FUNCTION Primera (lista: tListaOrdenada): tPosL;
FUNCTION Ultima (lista: tListaOrdenada): tPosL;	
FUNCTION Siguiente (lista: tListaOrdenada; posicion: tPosL): tPosL;
FUNCTION Anterior (lista: tListaOrdenada; posicion: tPosL): tPosL;
FUNCTION InsertarDato (VAR lista: tListaOrdenada; dato: tDato): boolean;
FUNCTION ObtenerDato (lista: tListaOrdenada; posicion: tPosL): TDato;
FUNCTION ActualizarDato (lista: tListaOrdenada; posicion: tPosL; tipo: tTipoUsuario; reproducciones: tNumReproducciones): tListaOrdenada;
FUNCTION BuscarDato (lista: tListaOrdenada; nombre: tNickUsuario): tPosL;
FUNCTION EliminarPosicion (lista: tListaOrdenada; posicion: tposL): tListaOrdenada;

IMPLEMENTATION

	(***********************************************************)
	FUNCTION ListaVacia: tListaOrdenada;
	
	(* OBJETIVO: Crea una lista vacía 
	   SALIDAS: la lista creada *)
	
	BEGIN
		ListaVacia:= NULO;
	END;
	(***********************************************************)
	
	(***********************************************************)
	FUNCTION esListaVacia (lista: tListaOrdenada): boolean;
	
	(* OBJETIVO: Si la lista que le pasas es vacía te devuelve TRUE, FALSE en cualquier otro caso
	   ENTRADAS: Una lista
	   SALIDAS: Un boolean *)
	
	BEGIN
	esListaVacia:= (lista = NULO);
	END;
	(***********************************************************)
	
	(***********************************************************)
	FUNCTION Primera (lista: tListaOrdenada): tPosL;
	
	(* OBJETIVO: Devuelve un puntero a la primera posición de la lista, nulo si es vacía
	   ENTRADAS: Una lista
	   SALIDAS: Un puntero a una posición *)

	BEGIN
		Primera:= lista;
	END;
	(***********************************************************)
	
	(***********************************************************)
	FUNCTION Ultima (lista: tListaOrdenada): tPosL;
	
	(* OBJETIVO: Devuelve un puntero a la última posición de la lista, nulo si es vacía
	   ENTRADAS: Una lista
	   SALIDAS: Un puntero a una posición *)
	
	VAR
		puntero: tPosL;
	BEGIN
		puntero:= lista;
		If NOT(eslistavacia(lista)) THEN
		   While puntero^.siguiente <> NULO DO
		      puntero:= puntero^.siguiente; (*Mientras la posición no es la última, pasa a la siguiente posición del puntero*)
		Ultima:= puntero;
	END;
	(***********************************************************)
	
	(***********************************************************)
	FUNCTION Siguiente (lista: tListaOrdenada; posicion: tPosL): tPosL;
	
	(* OBJETIVO: Devuelve la siguiente posición en una lista a una posición dada. Devuelve nulo si la posición es la última de la lista
	   ENTRADAS: Una lista y un puntero a una posición
	   SALIDAS: Un puntero a una posición *)
	
	VAR
		temporal: tPosL = NULO;
		
	BEGIN
	(*Si la posición no es la última (No existe la siguiente a la última) y la lista no está vacía*)
		If (posicion^.siguiente <> NULO) and (NOT (eslistavacia(lista))) Then
		   temporal := posicion^.siguiente;
      Siguiente:= temporal;
	END;
	(***********************************************************)
	
	(***********************************************************)
	FUNCTION Anterior (lista: tListaOrdenada; posicion: tPosL): tPosL;

	(* OBJETIVO: Devuelve la anterior posición en una lista a una posición dada. Devuelvo nulo si la posición es la primera
	   ENTRADAS: Una lista y un puntero a una posición
	   SALIDAS: Un puntero a una posición *)
	   
	VAR
		puntero: tPosL;
	BEGIN 
	
		puntero:= lista;
		If (NOT (eslistavacia(lista))) AND (posicion <> Primera(lista)) THEN
		(*Si la posición no es la última (No existe la siguiente a la última) y la lista no está vacía*)
			While puntero^.siguiente <> posicion DO
				puntero:= puntero^.siguiente
	   (*Mientras el siguiente del puntero en el que estamos no sea la posición, pasa al siguietne, hasta que el siguiente sea la posición, con lo cual estamos en el anterior*)
		Else 
			puntero:= NULO; (* si es vacía o la posición es la última, devuelve nulo*)
		Anterior:= puntero;
	END;
	(***********************************************************)
	
	(***********************************************************)
	FUNCTION InsertarDato (VAR lista: tListaOrdenada; dato: tDato): boolean; (*ORDENA MAL OLALLA*)
	
	(* OBJETIVO: Inserta en una lista un dato en la posición que ocuparía siguiendo la ordenación ASCII por el nombre
      ENTRADAS. Una lista y el dato
	   SALIDAS: Un Boolean que indica si se ha podido insertarlo correctamente
	   PRECONDICION: La lista está ordenada*)
	  
	VAR
		puntero: tPosL;
		sepuede: boolean;
		posicion: tPosL;
		
	(***********************************************************)
	FUNCTION CrearNodo (VAR puntero: tPosL): boolean;
   (* Lo hicimos en una función a parte para modularizar *)
                
	BEGIN
		new(puntero);
		CrearNodo:= (puntero <> NULO);
	END;
	(***********************************************************)
	
	(***********************************************************)
	FUNCTION PosicionInsertar (lista: tListaOrdenada; nombre: tNickUsuario): tPosL;
	(*Función que calcula la posición de inserción.
	  ENTRADAS: la lista ordenada y el nick del usuario a insertar
	  SALIDAS: Devuelve la posición en la que se ha de insertar el elemento.
	  PRECONDICIONES: lista no vacía
	  POSTCONDICIONES: devuelve NULO si la posición es la última*)
	  
	VAR
		puntero: tPosL;
	BEGIN
		puntero:= lista;
		While (puntero <> NULO) and (nombre > puntero^.datos.nickUsuario) DO
			puntero:= puntero^.siguiente;
	PosicionInsertar:= puntero;
	END;
	(***********************************************************)
	BEGIN
		sepuede:= CrearNodo(puntero);
		If sepuede THEN 
			If esListaVacia(lista) THEN BEGIN
				puntero^.datos:= dato;
				puntero^.siguiente:= NULO;
				lista:= puntero;
			END
			ELSE BEGIN
				posicion:= PosicionInsertar (lista, dato.nickUsuario);
				If posicion = NULO THEN BEGIN
					posicion:= Ultima(lista);
					puntero^.datos:= dato;
					posicion^.siguiente:= puntero;
					puntero^.siguiente:= NULO;
				END
				ELSE BEGIN
					puntero^.datos:= posicion^.datos;
					posicion^.datos:= dato;
					puntero^.siguiente:= posicion^.siguiente;
					posicion^.siguiente:= puntero;
				END;	
			END;
		InsertarDato:= sepuede;
	END; 
	(***********************************************************)
	
	(***********************************************************)
	FUNCTION ObtenerDato (lista: tListaOrdenada; posicion: tPosL): TDato;
	
	(* OBJETIVO: Obtiene el dato existente en la posición indicada
	   ENTRADAS: La lista y la posición
	   SALIDAS: El dato
	   PRECONDICIONES: La lista no está vacía y la posición es una posición válida *)

	BEGIN
		ObtenerDato:= posicion^.datos;
	END;
	(***********************************************************)
	
	(***********************************************************)
	FUNCTION ActualizarDato (lista: tListaOrdenada; posicion: tPosL; tipo: tTipoUsuario; reproducciones: tNumReproducciones): tListaOrdenada;
	
	(* OBJETIVO: Actualiza los datos de un usuario
	   ENTRADAS: La lista, la posición del usuario y el tipo y numero de reproducciones  a los que se quiere actualizar
	   SALIDAS: La lista
	   PRECONDICIONES: La lista no está vacía, la posición es una posición válida, el tipo de usuario es o normal o premium y y el numero de reproducciones es un entero *)

	BEGIN
		With posicion^.datos DO BEGIN
			numReproducciones:= reproducciones;
			tipoUsuario:= tipo;
		END;
		ActualizarDato:= lista;
	END;
	(***********************************************************)
	
	(***********************************************************)
	FUNCTION BuscarDato (lista: tListaOrdenada; nombre: tNickUsuario): tPosL;
	
	(* OBJETIVO: Devuelve la posición de la lista en la que aparece por primera vez el nombre de usuario indicado. NULO si no existe.
	   ENTRADAS: La lista y el nombre 
	   SALIDAS: Un puntero a la posición
	   PRECONDICION: La lista no está vacía *)
	
	VAR
		puntero: tPosL;
		encontrado: boolean = FALSE;

	BEGIN
		puntero:= lista;
		While (puntero <> NULO) and (upcase(nombre) >= upcase(puntero^.datos.nickUsuario)) and (NOT (encontrado)) DO 
		(* si el nombre va después que a lo que apunta el puntero, éste no es el último y no se ha encontrado, haz lo siguiente *)
			If (upcase(nombre) = upcase(puntero^.datos.nickUsuario)) THEN
				encontrado:= TRUE (* si el nombre y el nickusuario son iguales, se ha encontrado*)
			ELSE
				puntero:= puntero^.siguiente; (* si no, pasa al siguiente nodo*)
		If (NOT (encontrado)) THEN
			puntero:= NULO; (* y si no se ha encontrado, devuelve nulo *)
		BuscarDato:= puntero;
	END;
	(***********************************************************)
	
	(***********************************************************)
	FUNCTION EliminarPosicion (lista: tListaOrdenada; posicion: tposL): tListaOrdenada;
	
	(* OBJETIVO: Elimina la posición indicada en la lista
	   ENTRADAS: La lista y un puntero a una posición
	   SALIDAS: La lista sin la posición
	   PRECONDICION: La lista no está vacía y la posición es una posición válida*)
	   
	VAR
		puntero: tPosL;

	BEGIN
		If posicion = lista THEN
			lista:= lista^.siguiente //si lo que hay que eliminar es la primera posición, igualo lista a su siguiente. Si es NULO, es que la lista era de 1 elemento
		ELSE
			If posicion^.siguiente = NULO THEN
				Anterior(lista, posicion)^.siguiente:= NULO
			ELSE
				BEGIN
					puntero:= posicion^.siguiente; //hace que puntero apunte al siguiente de la posición
					posicion^.datos:= puntero^.datos; //iguala los datos de la posición que queremos eliminar a los datos de la siguiente 
					posicion^.siguiente:= puntero^.siguiente; //desenlazo a lo que apunta puntero
					posicion:= puntero; //finalmente, hace que posición también apunte a lo que apunta puntero, para poder hacer el dispose		
				END;
		dispose(posicion);
		EliminarPosicion:= lista;
	END;
	(***********************************************************)
END.
