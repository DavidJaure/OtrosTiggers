SELECT * FROM sumerca.factura;
SET @currentUserId = 1; -- Suponiendo que el usuario con ID 1 está realizando la acción
/*Informes de venta para empleados.*/ 
drop table venta;
CREATE TABLE IF NOT EXISTS venta (
    idAuditoria INT AUTO_INCREMENT PRIMARY KEY,
    numeroFactura INT,
    idUsuario INT,
    accion VARCHAR(50),
    nombreVendedor VARCHAR(100),
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP
);

drop trigger if exists ventaFactura;
DELIMITER $$

CREATE TRIGGER ventaFactura
AFTER INSERT ON factura
FOR EACH ROW
BEGIN
    DECLARE nombreVendedor VARCHAR(100);

    -- Obtener el nombre del vendedor asociado a la factura
    SELECT U.nombre INTO nombreVendedor
    FROM vendedor V
    JOIN Usuarios U ON V.Cedula = U.idUsuarios
    WHERE V.Cedula = NEW.idVendedor;

    -- Insertar un registro en la tabla de auditoría
    INSERT INTO venta (numeroFactura, idUsuario, accion, nombreVendedor)
    VALUES (NEW.numeroFactura, NEW.idVendedor, 'Inserción de factura', nombreVendedor);
END $$

DELIMITER ;


select * from venta;
select * from factura;


