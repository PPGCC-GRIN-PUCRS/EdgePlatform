// package com.grin.edgeplatform.configurations;

// import org.springframework.web.bind.annotation.ControllerAdvice;
// import org.springframework.web.bind.annotation.ExceptionHandler;
// import org.springframework.http.ResponseEntity;
// import org.springframework.http.HttpStatus;

// @ControllerAdvice
// public class GlobalExceptionHandler {

// // @ExceptionHandler(Throwable.class)
// // public ResponseEntity<String> handle(Throwable e) {
// // return
// //
// ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
// // }

// // @ExceptionHandler(MethodArgumentNotValidException.class)
// // public ResponseEntity<String> handle(MethodArgumentNotValidException e) {
// // return ResponseEntity.badRequest()
// // .body(String.join(";", e.getAllErrors().stream().map(objectError ->
// // toString(objectError)).toList()));
// // }
// //
// // public static String toString(ObjectError objectError) {
// //
// // if (objectError instanceof FieldError) {
// // FieldError fieldError = (FieldError) objectError;
// // return String.format("campo=[%s] mensagem=[%s]", fieldError.getField(),
// // fieldError.getDefaultMessage());
// // } else {
// // return String.format(" mensagem=[%s]", objectError.getDefaultMessage());
// // }
// //
// // }
// //
// // @ExceptionHandler(RecursoNaoEncontradoException.class)
// // public ResponseEntity<String> handle(RecursoNaoEncontradoException e) {
// // return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
// // }
// //
// // @ExceptionHandler(RecursoJaExistenteException.class)
// // public ResponseEntity<String> handle(RecursoJaExistenteException e) {
// // return ResponseEntity.status(HttpStatus.CONFLICT).body(e.getMessage());
// // }
// //
// // @ExceptionHandler(RecursoInvalidoExpection.class)
// // public ResponseEntity<String> handle(RecursoInvalidoExpection e) {
// // return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
// // }
// //
// // @ExceptionHandler(RecursoAusenteException.class)
// // public ResponseEntity<String> handle(RecursoAusenteException e) {
// // return
// //
// ResponseEntity.status(HttpStatus.UNPROCESSABLE_ENTITY).body(e.getMessage());
// // }
// //
// // @ExceptionHandler(RespostaDuplicadaException.class)
// // public ResponseEntity<String> handle(RespostaDuplicadaException e) {
// // return ResponseEntity.status(HttpStatus.CONFLICT).body(e.getMessage());
// // }

// }
