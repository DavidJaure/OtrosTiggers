SELECT * FROM sumerca.inventario; /* mantener actualizado el inventario una vez se realice una venta.*/

use sumerca; 
select * from factura;

DELIMITER $$
    
CREATE TRIGGER RestarInventarioVenta
AFTER INSERT ON factura
FOR EACH ROW
BEGIN
    DECLARE CantidadInventario INT;

    -- Obtener la cantidad actual en el inventario del producto vendido
    SELECT cantidad INTO cantidadInventario
    FROM inventario
    WHERE idProducto = NEW.idProducto;

    -- Verificauditoria_insert_facturaa que haya suficiente inventario disponible
    IF cantidadInventario >= NEW.cantidad THEN
        -- Restar la cantidad vendida del inventario
        UPDATE inventario
        SET cantidad = cantidad - NEW.cantidad
        WHERE idProducto = NEW.idProducto;
    ELSE
        -- Si no hay suficiente inventario, generar un error
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cantidad insuficiente en inventario para el producto';
    END IF;
END $$

DELIMITER ;

SELECT * FROM inventario;
SELECT * FROM factura;
SELECT * FROM inventario;