#!/usr/bin/php
<?php
$openSell = 0;
$errorRes = 0;

// Переменные ставим свои -->
// we put our variables -->
$summSell = 1;//Сколько монет продаём \ how many coins do we sell
$summSellTxt = "1";//Сколько монет продаём txt-формат !!!! \ how many coins do we sell, txt format
$pairOrder = "eth_usd";//Пара, которой торгуем \ pair we trade
$rateOrder = "10000";//Цена продажи \ Selling price
$moneta = "eth";//Монета, которую продаём \ Coin, which we sell
// <-- Переменные ставим свои
// <-- we put our variables

$k = 0;//s4et4ik koli4estva orderov (do $summOrder)
$orderSellAdd = 0;//skolko orderov na prodazu postavili
//$summOrder = 1;//Сколько хотим продать всего, $summSell должно быть кратно $summOrder
$summOrder = $summSell;

// Получаем api_key, api_secret, nonce -->
// get api_key, api_secret, nonce -->
$file_api_key = fopen("api_key", "r");
$buffer_api_key = fgets($file_api_key, 4096);
fclose($file_api_key);

$file_api_secret = fopen("api_secret", "r");
$buffer_api_secret = fgets($file_api_secret, 4096);
fclose($file_api_secret);

$file_nonce = fopen("nonce", "r");
$buffer_nonce = fgets($file_nonce, 4096);
fclose($file_nonce);

$api_key    = $buffer_api_key;
$api_secret = $buffer_api_secret;
$nonce      = $buffer_nonce;
// <-- get api_key, api_secret, nonce
// <-- Получаем api_key, api_secret, nonce

// Создаём файл errors под ошибки -->
$fp = fopen("errors", "w+"); // Создаём файл errors
$create_errors_file = fwrite($fp, "\n"); // Запись в файл errors
if ($create_errors_file) echo "\nФайл errors успешно создан.\n";
else echo "\nОшибка создания файла errors!\n";
fclose($fp); //Закрытие файла errors
// <-- Создаём файл errors под ошибки

	for($nonce;$nonce<2147483646;$nonce++)
	{
		$req['method'] = "getInfo";
		$req['nonce'] = $nonce;
		$post_data = http_build_query($req, '', '&');
		$sign = hash_hmac("sha512", $post_data, $api_secret);
		$headers = array(
			'Sign: '.$sign,
			'Key: '.$api_key,
		);

		$ch = null;
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/4.0 (compatible; SMART_API PHP client; '.php_uname('s').'; PHP/'.phpversion().')');
		curl_setopt($ch, CURLOPT_URL, 'https://yobit.net/tapi/');
		curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data);
		curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
		curl_setopt($ch, CURLOPT_ENCODING , 'gzip');
		$res = curl_exec($ch);
		$nonce++;
		if($res === false)
		{
			echo "\nERROR! curl_exec method getInfo!\n";
			$text_error = "\nERROR! curl_exec method getInfo!\n";
			//пишем Error в файл errors
			$fp = fopen("errors", "a"); // Открываем файл errors в режиме дозаписи
			$write_error = fwrite($fp, $text_error); // Запись в файл errors
			if ($write_error) echo "\nДанные в файл errors успешно занесены.\n";
			else echo "\nОшибка при записи в файл errors!\n";
			fclose($fp); //Закрытие файла errors
			curl_close($ch);
			$errorRes++;
			goto m2;
		}
		
		$result = json_decode($res, true);
		if($result['success'] == 0)
		{
			echo "\nERROR! Method getInfo! ".$result['error']."\n";
			$text_error = "\nERROR! Method getInfo! ".$result['error']."\n";
			//пишем Error в файл errors
			$fp = fopen("errors", "a"); // Открываем файл errors в режиме дозаписи
			$write_error = fwrite($fp, $text_error); // Запись в файл errors
			if ($write_error) echo "\nДанные в файл errors успешно занесены.\n";
			else echo "\nОшибка при записи в файл errors!\n";
			fclose($fp); //Закрытие файла errors
			curl_close($ch);
			$errorRes++;
			goto m2;
		}
		else if($result['success'] == 1)
		{
			curl_close($ch);

			if ($result['return']['funds'][$moneta] == $summSell || $result['return']['funds'][$moneta] > $summSell)
			{
				echo "Order na ".$summSell." monet sozdaetsa!\n";

				$reqOrder['method'] = "Trade";
				$reqOrder['pair'] = $pairOrder;
				$reqOrder['type'] = "sell";
				$reqOrder['rate'] = $rateOrder;
				$reqOrder['amount'] = $summSellTxt;
				$reqOrder['nonce'] = $nonce;
				$post_dataOrder = http_build_query($reqOrder, '', '&');
				$sign = hash_hmac("sha512", $post_dataOrder, $api_secret);
				$headersOrder = array(
				'Sign: '.$sign,
				'Key: '.$api_key,
				);
				$ch = null;
				$ch = curl_init();
				curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
				curl_setopt($ch, CURLOPT_USERAGENT, 'Mozilla/4.0 (compatible; SMART_API PHP client; '.php_uname('s').'; PHP/'.phpversion().')');
				curl_setopt($ch, CURLOPT_URL, 'https://yobit.net/tapi/');
				curl_setopt($ch, CURLOPT_POSTFIELDS, $post_dataOrder);
				curl_setopt($ch, CURLOPT_HTTPHEADER, $headersOrder);
				curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
				curl_setopt($ch, CURLOPT_ENCODING , 'gzip');
				$resOrder = curl_exec($ch);
				$nonce++;
				
				if($resOrder === false)
				{
					echo "\nERROR! curl_exec method Trade!\n";
					$text_error = "\nERROR! curl_exec method Trade!\n";
					//пишем Error в файл errors
					$fp = fopen("errors", "a"); // Открываем файл errors в режиме дозаписи
					$write_error = fwrite($fp, $text_error); // Запись в файл errors
					if ($write_error) echo "\nДанные в файл errors успешно занесены.\n";
					else echo "\nОшибка при записи в файл errors!\n";
					fclose($fp); //Закрытие файла errors
					curl_close($ch);
					$errorRes++;
					goto m2;
				}
				
				$result_decode = json_decode($resOrder, true);
				if($result_decode['success'] == 0)
				{
					echo "\nERROR! Method Trade! ".$result_decode['error']."\n";
					$text_error = "\nERROR! Method Trade! ".$result_decode['error']."\n";
					//пишем Error в файл errors
					$fp = fopen("errors", "a"); // Открываем файл errors в режиме дозаписи
					$write_error = fwrite($fp, $text_error); // Запись в файл errors
					if ($write_error) echo "\nДанные в файл errors успешно занесены.\n";
					else echo "\nОшибка при записи в файл errors!\n";
					fclose($fp); //Закрытие файла errors
					curl_close($ch);
					$errorRes++;
					goto m2;
				}
				else if($result_decode['success'] == 1)
				{
					echo "\nMethod Trade good success! \n";
					curl_close($ch);
					$k++;
				}
				else
				{
					echo "Unknown error method Trade!";
					$text_error = "\nERROR! Unknown error method Trade!\n";
					//пишем Error в файл errors
					$fp = fopen("errors", "a"); // Открываем файл errors в режиме дозаписи
					$write_error = fwrite($fp, $text_error); // Запись в файл errors
					if ($write_error) echo "\nДанные в файл errors успешно занесены.\n";
					else echo "\nОшибка при записи в файл errors!\n";
					fclose($fp); //Закрытие файла errors
					curl_close($ch);
					$errorRes++;
					goto m2;
				}
			}
			else
			{
				echo "Order na ".$summSell." monet waiting\n";
				$bayToMonet = $summSell - $result['return']['funds'][$moneta];
				echo "Bay to monet: ".$bayToMonet."\n";
				echo "Cena prodazi ordera: ".$rateOrder."\n";
				echo "Orderov ustanovleno: ".$k." iz ".$summOrder."\n";
				echo "Errors: ".$errorRes."\n";
			}
		}
		else
		{
			echo "Unknown error method getInfo!";
			$text_error = "\nERROR! Unknown error method getInfo!\n";
			//пишем Error в файл errors
			$fp = fopen("errors", "a"); // Открываем файл errors в режиме дозаписи
			$write_error = fwrite($fp, $text_error); // Запись в файл errors
			if ($write_error) echo "\nДанные в файл errors успешно занесены.\n";
			else echo "\nОшибка при записи в файл errors!\n";
			fclose($fp); //Закрытие файла errors
			curl_close($ch);
			$errorRes++;
			goto m2;
		}
		
		if($k>=$summOrder)
		{
			$openSell = 1;
			goto m1;
		}
m2:
		echo "nonce = ".$nonce."\n\n";
		//пишем Nonce в файл nonce
		$fp = fopen("nonce", "w+"); // Открываем файл nonce в режиме записи
		$write_nonce = fwrite($fp, $nonce); // Запись в файл nonce
		if ($write_nonce) echo "\nДанные в файл nonce успешно занесены.\n";
		else echo "\nОшибка при записи в файл nonce!\n";
		fclose($fp); //Закрытие файла nonce
		echo "delay 3\n";
		sleep(1);
		echo "delay 2\n";
		sleep(1);
		echo "delay 1\n";
		sleep(1);
		echo "\n\n";
	}
	m1:
	
	if($openSell == 1)
	{
		echo "Order sucess!\n\n";
		echo "Nonce: ".$nonce."\n\n";
		//пишем Nonce в файл nonce
		$fp = fopen("nonce", "w+"); // Открываем файл nonce в режиме записи
		$write_nonce = fwrite($fp, $nonce); // Запись в файл nonce
		if ($write_nonce) echo "\nДанные в файл nonce успешно занесены.\n";
		else echo "\nОшибка при записи в файл nonce!\n";
		fclose($fp); //Закрытие файла nonce
	}

$api_key    = NULL;
$api_secret = NULL;
$buffer_api_key = NULL;
$buffer_api_secret = NULL;
echo "\nEnd script\n";
?>
