SELECT e.EntityName, b.BalanceDate, b.Balance, s.Status FROM Entity e JOIN Balances b ON e.EntityId = b.EntityId
LEFT JOIN (SELECT bal.EntityId, bal.BalanceDate, max(st.StatusDate) AS MaxStatusDate
FROM Balances bal INNER JOIN Status st ON bal.EntityId = st.EntityId
WHERE st.StatusDate <= bal.BalanceDate GROUP BY bal.EntityId, bal.BalanceDate) RCol on RCol.EntityId = b.EntityId
AND RCol.BalanceDate = b.BalanceDate
LEFT JOIN Status s ON RCol.EntityId = s.EntityId AND RCol.MaxStatusDate = s.StatusDate
WHERE e.entityName = 'ABCD' ORDER BY b.BalanceDate DESC;


SELECT e.EntityName, s.Status, s.StatusDate, b.AverageBalance FROM Entity e JOIN (
SELECT bal.EntityId, AVG(bal.Balance) AverageBalance FROM Balances bal GROUP BY bal.EntityId) b ON e.EntityId = b.EntityId
JOIN (SELECT EntityId, MAX(s.StatusDate) StatusDate FROM Status s GROUP BY EntityId) RCol ON RCol.EntityId = b.EntityId
JOIN Status s ON RCol.EntityId = s.EntityId AND RCol.StatusDate = s.StatusDate;





