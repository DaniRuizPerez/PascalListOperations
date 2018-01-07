program principal;
(*Prácticas de PROGRAMACION II
Practica 1
AUTOR 1: Ruiz Pérez Daniel LOGIN 1: d.ruiz.perez
AUTOR 2: Barbeito Vázquez Ismael LOGIN 2: i.barbeito
GRUPO: 2.3.2
FECHA: 30/03/2012*)
USES sysutils, listadinamica; //listaestatica

(***********************************************************)
PROCEDURE Alta (usuario: tNickUsuario; tipo: string; VAR lista: tListaOrdenada);
{Objetivo: Alta de un usuario de tipo normal o Premium
Entradas: Un Usuario, un tipo  y la lista sobre la que trabajar
Postcondiciones y salidas: el usuario queda ordenado alfabéticamente en la lista. Escribirá por pantalla un mensaje de confirmación si ha podido hacer la operación o de error en caso de que el usuario ya exista en la lista, el tipo de usuario no sea reconocido, o la lista esta llena.
}
VAR
	dato: tDato;
BEGIN
	If (tipo <> 'normal') AND (tipo <> 'premium') THEN //Si el tipo no es uno reconocido, da error. Ya que tipo es un string, uso comillas.
		Writeln ('++++ Error de Alta: El tipo de usuario no ha podido ser reconocido')
	ELSE
		If BuscarDato (lista, usuario) <> NULO THEN //Si BuscarDato no es nulo, el usuario no existe.
			Writeln ('++++ Error de Alta: El nick de usuario ', usuario,' no esta disponible')
		ELSE BEGIN
			dato.nickUsuario:= usuario;
			If tipo = 'normal' THEN //Selecciono el tipo y lo guarda en dato
				dato.tipoUsuario:= normal //Este "normal" es del tTipoUsuario, por eso no lleva comillas
			ELSE
				dato.tipoUsuario:= premium;
			dato.numReproducciones:= 0; //El usuario, al darse de alta, aún no ha hecho reproducciones
			If NOT (InsertarDato (lista, dato)) THEN //Si no se ha podido insertar dato, con estas implementaciones, es que el montículo/array está lleno
				Writeln ('++++ Error de Alta: la lista está llena')
			ELSE
				Writeln ('**** Alta de Usuario: Nick ',usuario,' Tipo Usuario ',tipo);
		END;
END;
(***********************************************************)

(***********************************************************)
PROCEDURE Baja (usuario: tNickUsuario; VAR lista: tListaOrdenada);
{Objetivo: Baja de un usuario
Entradas: Un Usuario y una lista sobra la que trabajar 
Postcondiciones y salidas: se devuelve la lista sin el usuario. Escribirá por pantalla un mensaje de confirmación si ha podido hacer la operación, o de error en caso de que el usuario no existiera en la lista inicialmente, o si la lista está vacía.
}
VAR
	posicion: tPosL;
	dato: tDato;

BEGIN
	If NOT esListaVacia(lista) THEN BEGIN //Si la lista está vacía, no satisfago las precondiciones de BuscarDato
		posicion:= BuscarDato (lista, usuario);
		If posicion = NULO THEN //Si posicion es NULO, es que el usuario no existe
			Writeln ('++++ Error en Baja: No existe el usuario con nick ',usuario)
		ELSE BEGIN
			dato:= ObtenerDato (lista, posicion); //Obtengo el dato para poder escribir luego a quién he borrado
			lista:= EliminarPosicion (lista, posicion);
			Writeln ('**** Baja de Usuario: Nick ',dato.nickUsuario,' Tipo Usuario ', dato.tipoUsuario, ' Reproducciones ',dato.numReproducciones:0); 
		END;	
	END
	ELSE
		Writeln ('++++ Error en Baja: No existe el usuario con nick ',usuario);
END;
(***********************************************************)

(***********************************************************)
PROCEDURE Actualizacion (usuario: tNickUsuario; VAR lista: tListaOrdenada);
{Objetivo: Actualización (upgrade) de un usuario de normal a Premium
Entradas: UN Usuario y la lista sobre la que trabajar
Postcondiciones y salidas: escribirá un mensaje de confirmación si ha podido hacer la operación. Si el usuario es Premium o no existe en la lista, devolverá un mensaje con el error correspondiente
}
VAR
	posicion: tPosL;
	dato: tDato;

BEGIN
	If NOT esListaVacia(lista) THEN BEGIN //Si la lista está vacía, no satisfago las precondiciones de BuscarDato
		posicion:= BuscarDato (lista, usuario);
		If posicion = NULO THEN //Si posicion es NULO, el usuario no existe
			Writeln ('++++ Error en Actualización: No existe el usuario con nick ',usuario)
		ELSE BEGIN
			dato:= ObtenerDato (lista, posicion);
			If dato.tipoUsuario = premium THEN //Si el usuario ya es premium, no puedo actualizarlo
				Writeln ('++++ Error en Actualización: Usuario ',usuario,' ya es premium')
			ELSE BEGIN
				lista:= ActualizarDato (lista, posicion, premium,dato.numReproducciones);
				Writeln ('**** Actualización de Usuario ',usuario,' a Premium'); 
		END;	
	END;
	END
	ELSE
		Writeln ('++++ Error en Reproducción: No existe el usuario con nick ',usuario);
END;
(***********************************************************)

(***********************************************************)
PROCEDURE Reproduccion (usuario: tNickUsuario; cancion: string; VAR lista: tListaOrdenada);
{Objetivo: Reproducción (play) de una canción por parte de un usuario
Entradas: Un usuario, una canción a reproducir y una lista sobre la que trabajar
Postcondiciones y salidas: escribirá un mensaje de confirmación si ha podido realizar la operación o uno de error si excede el máximo de reproducciones o si el usuario no existe.
}
VAR
	posicion: tPosL;
	dato: tDato;

BEGIN
	If NOT esListaVacia(lista) THEN BEGIN //Si la lista está vacía, no satisfago las precondiciones de BuscarDato
		posicion:= BuscarDato (lista, usuario);
		If posicion = NULO THEN //Si posicion es NULO, no existe el usuario
			Writeln ('++++ Error en Reproducción: No existe el usuario con nick ',usuario)
		ELSE BEGIN
			dato:= ObtenerDato (lista, posicion);
			dato.numReproducciones:= dato.numReproducciones+1;
			If (dato.tipoUsuario = normal) AND (dato.numReproducciones > MAXREP) THEN  //Los usuarios normales tiene un límite de reproducciones
				Writeln ('++++ Error en Reproducción: Usuario ',usuario,' ha excedido el número máximo de reproducciones')
			ELSE BEGIN
				lista:= ActualizarDato (lista, posicion, dato.tipoUsuario ,dato.numReproducciones);
				Writeln ('**** Usuario ',usuario,' Reproduce Cancion ',cancion,'. Total Reproducciones ',dato.numReproducciones); 
			END;
		END;
	END
	ELSE
		Writeln ('++++ Error en Reproducción: No existe el usuario con nick ',usuario);
END;
(***********************************************************)
   
(***********************************************************)
PROCEDURE MostrarLista (lista: tListaOrdenada);
{Objetivo: Listado de usuarios de ESPOTIFIC junto con sus datos
Entradas: La lista a mostrar
Postcondiciones y salidas: imprime por pantalla la lista si no ha habido ningún error. En caso de que la lista esté vacía, lo indicará por pantalla con el error correspondiente.
}
VAR
	Pactual, Pultimo: tPosL;
	DatoActual: tDato;
	Fin: Boolean = FALSE;

BEGIN
	If NOT (esListaVacia(lista)) THEN BEGIN //Si la lista está vacía, muestro directamente el error del final
		Pactual:= Primera(lista);
		Pultimo:= Ultima(lista);
		Writeln ('**** Imprimiendo lista de usuarios');
		Repeat
			DatoActual:= ObtenerDato (lista, Pactual);	
			Writeln;
			Writeln ('Usuario ',DatoActual.nickUsuario:9,' Tipo Usuario ',DatoActual.tipoUsuario:7,' Reproducciones ',DatoActual.numReproducciones:0);
			if Pactual = Pultimo THEN Fin:= TRUE ELSE //Si el dato es el último, activo Fin y salgo
				Pactual:= Siguiente (lista, Pactual); //En caso contrario, hago el siguiente de Pactual
		Until Fin
		END
	ELSE
		Writeln ('++++ Error de Listado: La lista está vacía')
END;
(***********************************************************)

(***********************************************************)
PROCEDURE Estadisticas (lista: tListaOrdenada);
{Objetivo: Mostrar estadísticas de reproducciones. En concreto, mostrar
el total de reproducciones y el número medio de reproducciones por tipo de usuario.
Entradas: La lista de la que extraer las estadísticas.
Postcondiciones y salidas: imprime por pantalla las estadísticas indicadas. En caso de que la lista esté vacía, dará un error, imprimiendo el mensaje correspondiente por pantalla.
}
VAR
	Pactual, Pultimo: tPosL;
	DatoActual: tDato;
	numeronormal: integer = 0;
	cancionesnormal: integer = 0;
	numeropremium: integer = 0;
	cancionespremium: integer = 0;
	Fin: boolean = FALSE;
	medianormal: real = 0.0;
	mediapremium: real = 0.0;

BEGIN
	If NOT (esListaVacia(lista)) THEN BEGIN //Si la lista está vacía, lo indico como un error
		Pactual:= Primera(lista);
		Pultimo:= Ultima(lista);
		Repeat
			DatoActual:= ObtenerDato (lista, Pactual);
			If DatoActual.tipoUsuario = normal THEN BEGIN //Con este if compruebo si el usuario es normal o premium, para usar las variables adecuadas
				cancionesnormal:= cancionesnormal + DatoActual.numReproducciones;
				numeronormal:=numeronormal+1;
			END
			ELSE BEGIN
				cancionespremium:= cancionespremium + DatoActual.numReproducciones;
				numeropremium:=numeropremium+1;
			END;
			if Pactual = Pultimo THEN Fin:= TRUE ELSE
				Pactual:= Siguiente (lista,Pactual);
		Until Fin;
		If numeropremium <> 0 THEN
			mediapremium:= cancionespremium/numeropremium;
		If numeronormal <> 0 THEN
			medianormal:= cancionesnormal/numeronormal;
		Writeln ('| --------------  | ---------- |  -------------------- |');
		Writeln ('| REPRODUCCIONES  |   TOTALES  |   MEDIAS POR USUARIO  |');
		Writeln ('| --------------  | ---------- |  -------------------- |');
		Writeln ('| Usuario Normal  |',cancionesnormal:7,'     |',(medianormal):12:2,'           |');
		Writeln ('| --------------  | ---------- | --------------------  |');	
		Writeln ('| Usuario Premium |',cancionespremium:7,'     |',(mediapremium):12:2,'           |');
		Writeln ('| --------------  | ---------- | --------------------  |');
	END 
	ELSE
		Writeln ('++++ Error de Estadísticas: La lista está vacía')
	END;
(***********************************************************)

(***********************************************************)
PROCEDURE lectura;
{Objetivo: Leer el fichero con los datos que e instrucciones que usará el programa, así como gestionar el llamamiento al resto de procedimientos.
Entradas: No tiene
Postcondiciones y salidas: aparte de las salidas propias de los procedimientos anteriores (que quedan englobadas en “Lectura”), el procedimiento tiene dos salidas propias, que son el caso de que no logre leer el fichero (indicándolo por pantalla y terminando la ejecución), y el caso de que una instrucción dada no sea válida (imprimirá por pantalla un error y seguirá con el siguiente elemento).
}
VAR
	lista: tListaOrdenada;
   fichero: text;
   linea: string;
   operacion: string;
   nickUsuario: string;
   tipoOCancion: string;

BEGIN
   {$i-}
   Assign(fichero, 'usuarios.txt');
   Reset(fichero);
   {$i+}
   IF (IoResult <> 0) THEN BEGIN
      writeln('*** principal.pas: error al acceder al fichero usuarios.txt');
      halt(1)
   END;
   lista:= ListaVacia;
   WHILE NOT EOF(fichero) DO BEGIN
      readLn(fichero, linea);
      operacion:= linea[1];
      nickUsuario:= trim(copy(linea,3,9));
      tipoOCancion:= trim(copy(linea,14,20)); 
      Case operacion[1] OF //Selector para cada caso. Uso el primer elemento del string para poder usar el case
      	'A': Alta (nickUsuario, tipoOCancion, lista);
      	'B': Baja (nickUsuario, lista);
      	'U': Actualizacion (nickUsuario, lista);
      	'P': Reproduccion (nickUsuario, tipoOCancion, lista);
			'L': MostrarLista(lista);
			'S': Estadisticas (lista);
			otherwise Writeln ('++++ Error en procesado: operación no reconocida');
			END;
		Writeln;
   END;
   Close(fichero);
END;
(***********************************************************)
BEGIN
	lectura;
END.
