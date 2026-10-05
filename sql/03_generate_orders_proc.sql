DELIMITER //

DROP PROCEDURE IF EXISTS GenerateOrders //


CREATE PROCEDURE GenerateOrders(IN total INT)
BEGIN

#定义
	DECLARE  	i INT DEFAULT 1;
	DECLARE	v_order_no VARCHAR(32);
	DECLARE	v_qty INT;
	DECLARE	v_price DECIMAL(10,2);

	DECLARE v_max_order_no VARCHAR(32);
	DECLARE v_current_seq INT;#当天订单流水
	DECLARE v_today_str VARCHAR(8);


#定义接收外键
	DECLARE v_user_id BIGINT;
	DECLARE v_product_id BIGINT;

	DECLARE v_max_user_id BIGINT;
	DECLARE v_min_user_id BIGINT;
	DECLARE v_max_product_id BIGINT;
	DECLARE v_min_product_id BIGINT;



#异常处理-回滚
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    ROLLBACK;
    SET autocommit = 1;
    RESIGNAL;
END;

#获取父级表的真实id范围
	SELECT IFNULL(MAX(id),0),IFNULL(MIN(id),0) INTO v_max_user_id,v_min_user_id  FROM users;
	SELECT IFNULL(MAX(id),0),IFNULL(MIN(id),0) INTO v_max_product_id, v_min_product_id FROM products;



#关闭自动提交事务
	SET autocommit = 0 ;

#查询今天是否有订单
		SET v_today_str = DATE_FORMAT(NOW(),'%Y%m%d');

		SELECT MAX(order_no) INTO v_max_order_no
		FROM orders
		WHERE order_no LIKE CONCAT('ORD', v_today_str, '%' );
		
		IF v_max_order_no IS NULL THEN
			SET v_current_seq = 1;
		ELSE
			SET v_current_seq = CAST(RIGHT(v_max_order_no,6) AS UNSIGNED)+1;
		END IF;

#循环插入
	WHILE i <= total DO
		SET v_user_id = FLOOR(v_min_user_id +RAND()*(v_max_user_id - v_min_user_id +1));
		SET v_product_id = FLOOR(v_min_product_id +RAND()*(v_max_product_id -v_min_product_id  + 1));
		SET v_qty = FLOOR(1+RAND()*5);

		SELECT price INTO v_price 
		FROM products 
		WHERE id = v_product_id;
		SET v_order_no = CONCAT('ORD',v_today_str,LPAD(v_current_seq, 6, '0'));
		SET v_current_seq = v_current_seq +1;
		
		
		INSERT INTO orders ( order_no, user_id, product_id, quantity, amount, status, create_time) 
		VALUES(
			v_order_no,
			v_user_id,
			v_product_id,
			v_qty,
			v_price * v_qty,
			FLOOR(RAND()*5),
			DATE_SUB(NOW(), INTERVAL FLOOR(RAND() *365)DAY)
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

CALL GenerateOrders(5000);






