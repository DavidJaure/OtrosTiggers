/*ver el primer estado de la tabla*/
SELECT * FROM sumerca.factura;
/*Calcular el valor de la factura incluyendo el iva.*/

ALTER TABLE factura /*se crean las tablas donde se alojan los resultados del trigger*/
ADD COLUMN valorSinIVA DECIMAL(18,2) DEFAULT 0.00,
ADD COLUMN valorConIVA DECIMAL(18,2) DEFAULT 0.00;

SELECT * FROM sumerca.factura; /*observamos su creacion y que esten vacias*/

use sumerca;
DELIMITER //
CREATE TRIGGER calcularValoresFactura
BEFORE INSERT ON factura
FOR EACH ROW 
BEGIN
    DECLARE valorProducto DECIMAL(18,2);
    DECLARE iva DECIMAL(5,2) DEFAULT 0.19; /*19% de IVA*/

  
    SELECT valorVenta INTO valorProducto
    FROM productos
    WHERE idProducto = NEW.idProducto;
    SET NEW.valorSinIVA = NEW.cantidad * valorProducto;
    SET NEW.valorConIVA = NEW.valorSinIVA * (1 + iva);
END //
DELIMITER ;



drop trigger if exists calcularValoresFactura;

/*Valores necesario para llenar la factura*/
select * from sucursal;
select * from usuarios;
select * from vendedor;
select * from clientes;
select * from productos;
select * from inventario;
/*Ingresamos valores a la factura*/
select * from factura;
