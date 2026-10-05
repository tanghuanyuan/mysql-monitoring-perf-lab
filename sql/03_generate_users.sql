SET NAMES utf8mb4;
DELIMITER //

DROP PROCEDURE IF EXISTS GenerateUsers //


CREATE PROCEDURE GenerateUsers(IN total INT)
BEGIN
    DECLARE      i INT DEFAULT 1;
    DECLARE      id_size BIGINT;
    
#1.异常处理-回滚
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
            ROLLBACK;
            SET autocommit = 1;
            RESIGNAL;
    END;

#新增变量
    SELECT IFNULL(MAX(id), 0) INTO id_size FROM users;
    
#关闭自动提交事务
    SET autocommit = 0 ;


#循环插入
    WHILE i <= total DO
        INSERT INTO users (username, email, status, created_at) 
        VALUES(
            CONCAT('user_',id_size+i),
            CONCAT('user_',id_size+i,'@example.com'),
            FLOOR(RAND() * 2),
            DATE_SUB(NOW(),INTERVAL FLOOR(RAND() * 365) DAY)
        );
        IF i % 1000 = 0 THEN 
            COMMIT;
        END IF;
        SET i  = i+1;
    END WHILE;
    COMMIT;


    SET autocommit = 1 ;
END //
DELIMITER ;




CALL GenerateUsers(2000);