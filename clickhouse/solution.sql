-- Решение заданий по ClickHouse

-- 1. Создание таблицы
-- TODO: скопируйте и доработайте CREATE TABLE из schema.sql
CREATE TABLE IF NOT EXISTS server_logs
(
    timestamp datetime,
    user_id UInt32,
    endpoint String,
    response_time_ms UInt16,
    status_code UInt16
) ENGINE = MergeTree()
ORDER BY (timestamp, endpoint); -- TODO: выберите подходящий порядок сортировки

-- 2. Загрузка данных из CSV
-- Подсказка: можно использовать clickhouse-client с параметром --query
-- Пример команды (выполняется в терминале):
-- cat server_logs.csv | clickhouse-client --query="INSERT INTO server_logs FORMAT CSVWithNames"

--эта комманда все сделала)
--cat server_logs.csv | docker exec -i clickhouse clickhouse-client --query="INSERT INTO server_logs FORMAT CSVWithNames"


-- 3. Запрос: Топ-5 самых медленных endpoint'ов (по среднему времени ответа)
-- TODO: напишите SELECT запрос

SELECT
    endpoint,
    avg(response_time_ms) AS avg_response_time
FROM server_logs
GROUP BY endpoint
ORDER BY avg_response_time DESC
LIMIT 5;

-- 4. Запрос: Количество запросов по часам за весь период в логах
-- TODO: напишите SELECT запрос с использованием функции toHour() или formatDateTime()

SELECT
    toHour(timestamp) AS hour,
    count(*) AS request_count
FROM server_logs
GROUP BY hour
ORDER BY hour;

-- 5. Запрос: Процент ошибок (status_code >= 400) для каждого endpoint'а
-- TODO: напишите SELECT запрос с вычислением процента ошибок


SELECT
    endpoint,
    count(*) AS all_requests,
    round(countIf(status_code >= 400) * 100.0 / count(*), 2) AS error_percente
FROM server_logs
GROUP BY endpoint
ORDER BY error_percente DESC;
