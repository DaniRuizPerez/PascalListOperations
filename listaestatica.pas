UNIT listaestatica;
(*Prácticas de PROGRAMACION II
Practica 1
AUTOR 1: Ruiz Pérez Daniel LOGIN 1: d.ruiz.perez
AUTOR 2: Barbeito Vázquez Ismael LOGIN 2: i.barbeito
GRUPO: 2.3.2
FECHA: 30/03/2012*)
INTERFACE

CONST	
	NULO = 0;
	MAXREP = 3;
	MaxUsuarios = 100;

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
	tPosL = integer; 
	tArrayDatos = ARRAY [1..MaxUsuarios] OF TDato;
	tListaOrdenada = RECORD
		Datos: tArrayDatos;
		Fin: tPosL;
	END;

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
		SALIDA: la lista creada *)
	
	VAR
		lista: tListaOrdenada;
	
	BEGIN
		lista.fin:= NULO;
		ListaVacia:= lista;
	END;
	(***********************************************************)
	
	(***********************************************************)
	FUNCTION esListaVacia (lista: tListaOrdenada): boolean;
	
	(* OBJETIVO: Si la lista que le pasas es vacía te devuelve TRUE, FALSE en cualquier otro caso
	   ENTRADAS: Una lista
	   SALIDAS: Un boolean *)
	
	BEGIN
	esListaVacia:= (lista.Fin = NULO);
	END;
	(***********************************************************)
	
	(***********************************************************)
	FUNCTION Primera (lista: tListaOrdenada): tPosL;
	
	(* OBJETIVO: Devuelve la primera posición de la lista, nulo si es vacía
	   ENTRADAS: Una lista
	   SALIDAS: Una posición *)
	
	VAR
		temporal: tPosL;
	BEGIN
		If esListaVacia(lista) THEN
			temporal:= NULO
		Else
			temporal:= 1;
		Primera:= temporal;
	END;
	(***********************************************************)
	
	(***********************************************************)
	FUNCTION Ultima (lista: tListaOrdenada): tPosL;
	
	(* OBJETIVO: Devuelve la última posición de la lista, nulo si es vacía
	   ENTRADAS: Una lista
	   SALIDAS: Una posición *)
	
	VAR
		temporal: tPosL;
	BEGIN
		If esListaVacia(lista) THEN
			temporal:= NULO
		Else
			temporal:= lista.fin;
		Ultima:= temporal;
	END;
	(***********************************************************)
	
	(***********************************************************)
	FUNCTION Siguiente (lista: tListaOrdenada; posicion: tPosL): tPosL;
	
	(* OBJETIVO: Devuelve la siguiente posición en una lista a una posición dada. Devuelve nulo si la posición es la última de la lista
	   ENTRADAS: Una lista y una posición
	   SALIDAS: Una posición *)
	
	VAR
		temporal: tPosL = NULO;
	BEGIN
	If NOT (eslistavacia(lista)) THEN
		If lista.fin <> posicion THEN
			temporal:= posicion + 1;
		Siguiente:= temporal;
	END;
	(***********************************************************)
	
	(***********************************************************)
	FUNCTION Anterior (lista: tListaOrdenada; posicion: tPosL): tPosL;
	
	
	(* OBJETIVO: Devuelve la anterior posición en una lista a una posición dada. Devuelvo nulo si la posición es la primera
	   ENTRADAS: Una lista y una posición
	   SALIDAS: Una posición *)
	   
	VAR
		temporal: tPosL = NULO;
	BEGIN
		If NOT (eslistavacia(lista)) THEN
		If (NOT(lista.fin = 1) OR (NOT(posicion=1))) THEN
			temporal:= posicion - 1;
		Anterior:= temporal;
	END;
	(***********************************************************)
	
	(***********************************************************)
	FUNCTION InsertarDato (VAR lista: tListaOrdenada; dato: tDato): boolean;
	
	(* OBJETIVO: Inserta en una lista un dato en la posición que ocuparía siguiendo la ordenación ASCII por el nombre
           ENTRADAS. Una lista y el dato
	   SALIDAS: Un Boolean que indica si se ha podido insertarlo correctamente
	   PRECONDICION: La lista está ordenada*)
	
	VAR
		sepuede: boolean = TRUE;
		i: integer;
		pos: tPosL;
	
		(***********************************************************)
		FUNCTION ErroresInsercion (lista: tListaOrdenada; dato: tDato): boolean;
                (* Esta funcion te avisa del error que se produce cuando quieres meter un dato en una lista que ya está llena
                Lo hicimos en una función a parte para modularizar y por si se nos ocurrían mas errores después*)
                
		BEGIN
			ErroresInsercion:= lista.fin = MaxUsuarios;
		END;
		(***********************************************************)
			
		(***********************************************************)
		FUNCTION PosicionElemento (lista: tListaOrdenada; nombre: tNickUsuario): tPosL;
		(* Esta función te calcula la posición que ocuparía el elemento en la lista siguiendo una ordenación ASCII por el nombre*) 
			
		VAR
			i: integer = 1;
		BEGIN
			If NOT esListaVacia(lista) THEN  (* si la lista está vacía no hace lo siguiente y la posición = 1 *)
				If upcase(nombre) > upcase(lista.datos[1].nickUsuario) THEN
				    (* Si al nombre le corresponde una posición menor al dato en la primera posición no entra en el bucle y la posición que le corresponde es 1*)
					While ((upcase(nombre) > upcase(lista.datos[i].nickUsuario)) AND (i<=lista.fin))DO 
						i:= i+1;
		(* mientras que el dato vaya a la derecha de la posición que se está mirando y no se haya llegado al final, se le suma 1 a i. Si se ha llegado al final sin encontrar la posición correspondiente es por que va la última y se le suma 1 a i. ( por eso se pone AND (i<=lista.fin) ) *)       
              	
			PosicionElemento:= i
		END;
		(***********************************************************)

	BEGIN
		If ErroresInsercion (lista, dato) THEN
			sepuede:= false (* si la lista está llena, no se puede*)
		ELSE BEGIN
			pos:= PosicionElemento(lista,dato.nickUsuario);
			lista.fin:=lista.fin+1; (*asignamos a pos la posición que tiene que ocupar el elemento y habilitamos un elemento más al final de la lista*)
				If pos = Ultima(lista) THEN
					lista.datos[lista.fin]:= dato
				ELSE
					BEGIN
						For i:= lista.fin downto pos+1 DO
							lista.datos[i]:= lista.datos[i-1];
					lista.datos[pos]:= dato;	(* movemos todo una posición a la derecha y metemos el dato en pos*)
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
		ObtenerDato:= lista.Datos[posicion];
	END;
	(***********************************************************)
	
	(***********************************************************)
	FUNCTION ActualizarDato (lista: tListaOrdenada; posicion: tPosL; tipo: tTipoUsuario; reproducciones: tNumReproducciones): tListaOrdenada;
	
	(* OBJETIVO: Actualiza los datos de un usuario
	   ENTRADAS: La lista, la posición del usuario y el tipo y numero de reproducciones  a los que se quiere actualizar
	   SALIDAS: La lista
	   PRECONDICIONES: La lista no está vacía, la posición es una posición válida, el tipo de usuario es o normal o premium y y el numero de reproducciones es un entero *)

	BEGIN
		with lista.datos[posicion] DO BEGIN
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
	   SALIDAS: La posición
	   PRECONDICION: La lista no está vacía *)
	
	VAR
		encontrado: boolean = false;
		i: integer = 1;
		temporal: tPosL;

	BEGIN
		While ((NOT encontrado) AND (i<=lista.fin)) DO
			If lista.Datos[i].NickUsuario = nombre THEN
				encontrado:= TRUE
			Else
				i:= i+1;
	 (* Si se ha encontrado se para y si no, i+1 *)		
		If encontrado THEN
			temporal:= i
		ELSE
			temporal:= NULO; (* si no se ha encontrado es por que no está, y devuelve nulo*)
		Buscardato:= temporal;
	END;
	(***********************************************************)
	
	(***********************************************************)
	FUNCTION EliminarPosicion (lista: tListaOrdenada; posicion: tposL): tListaOrdenada;
	
	(* OBJETIVO: Elimina la posición indicada en la lista
	   ENTRADAS: La lista y la posición
	   SALIDAS: La lista sin la posición
	   PRECONDICION: La lista no está vacía y la posición es una posición válida*)
	   
	VAR
		i: integer = 1;

	BEGIN
		If (lista.fin <> 1) THEN BEGIN
			For i:= posicion + 1 TO lista.fin DO
				lista.datos[i-1]:= lista.datos[i];
			lista.fin:= lista.fin - 1; 
			END (* Desde posición + 1 mueve todos los elementos hacia la izquierda sobreescribiendo la posición a borrar. Luego se hace fin:= fin -1 para que no queden datos duplicados *)
		ELSE
			lista.fin:= NULO; (*si solo hay un elemento, basta con indicar que la lista esta vacía*)
		EliminarPosicion:= lista;
	END;
	(***********************************************************)
END.
