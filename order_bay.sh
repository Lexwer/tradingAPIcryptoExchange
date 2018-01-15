#!/usr/bin/php
<?php
$openSell = 0;

// Переменные ставим свои -->
// we put our variables -->
$summBay = 2;//Сколько монет покупаем \ How many coins we buy
$summBayTxt = "2";//Cколько монет покупаем txt-формат !!!! \ How many coins do we buy, txt format
$pairOrder = "eth_btc";//Пара, которой торгуем \ pair we trade
$rateOrder = "0.0001";//Цена покупки \ purchase price
$moneta = "eth";//Монета, которую покупаем \ Coin, which we buy
// <-- Переменные ставим свои
// <-- we put our variables

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

echo "\nOrder na ".$summBay." ".$moneta." sozdaetsa!\n";

$reqOrder['method'] = "Trade";
$reqOrder['pair'] = $pairOrder;
$reqOrder['type'] = "buy";
$reqOrder['rate'] = $rateOrder;
$reqOrder['amount'] = $summBayTxt;
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

if($resOrder === false)
{
	$e = curl_error($ch);
	debuglog($e);
	curl_close($ch);
	goto m1;
}

curl_close($ch);
$result_decode = json_decode($resOrder, true);

if($result_decode['success'] == 0)
{
	echo "\nERROR! ".$result_decode['error']."\n";
}
else if($result_decode['success'] == 1)
{
	$openSell = 1;
}
else
{
	echo "\nUnknown ERROR!\n";
}

m1:
	
if($openSell == 1)
{
	echo "\nOrder sucess!\n";
	echo "\nNonce: ".$nonce."\n";
	$nonce++;
	//пишем Nonce в файл
	$fp = fopen("nonce", "w+"); // Открываем файл в режиме записи
	$write_nonce = fwrite($fp, $nonce); // Запись в файл
	if ($write_nonce) echo "\nДанные в файл успешно занесены.\n";
	else echo "\nОшибка при записи в файл!\n";
	fclose($fp); //Закрытие файла
}
else
{
	//echo "\nErrors!";
	echo "\nNonce: ".$nonce."\n";
	$nonce++;
	//пишем Nonce в файл
	$fp = fopen("nonce", "w+"); // Открываем файл в режиме записи
	$write_nonce = fwrite($fp, $nonce); // Запись в файл
	if ($write_nonce) echo "\nДанные в файл успешно занесены.\n";
	else echo "\nОшибка при записи в файл!\n";
	fclose($fp); //Закрытие файла
	echo "\nERROR! NO CREATE ORDER!\n";
}

$api_key    = NULL;
$api_secret = NULL;
$buffer_api_key = NULL;
$buffer_api_secret = NULL;
echo "\nEnd script\n";
?>