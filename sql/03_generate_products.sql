SET NAMES utf8mb4;
DELIMITER //

DROP PROCEDURE IF EXISTS GenerateProducts //

CREATE PROCEDURE GenerateProducts(IN total INT)
BEGIN
    DECLARE i INT DEFAULT 1;

#接受外键

    DECLARE id_size BIGINT;

    # 1.异常处理-回滚
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET autocommit = 1;
        RESIGNAL;
    END;

    # 2.获取当前最大ID，用于拼接不重复的商品ID
    SELECT IFNULL(MAX(id), 0) INTO id_size FROM products;

    # 3.关闭自动提交事务
    SET autocommit = 0;

    # 4.循环插入
    WHILE i <= total DO
        INSERT INTO products (id, name, category_id, price, stock) 
        VALUES(
            id_size + i,                                      
            CONCAT('测试商品_', id_size + i),                  
            FLOOR(1 + RAND() * 7),                            
            ROUND(10 + RAND() * 1000, 2),                    
            FLOOR(RAND() * 500)                              
        );
        
        IF i % 1000 = 0 THEN 
            COMMIT;
        END IF;
        
        SET i = i + 1;
    END WHILE;

    COMMIT;
    SET autocommit = 1;

    # 5.提示成功
    SELECT CONCAT('成功新增 ', total, ' 条商品数据') AS msg;
END //

DELIMITER ;

CALL GenerateProducts(5000)