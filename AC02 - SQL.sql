---------------------------------------------------------------------------------------------------
-- AC02 - Algoritmos
---------------------------------------------------------------------------------------------------
declare @tbRA table (RA int primary key, nome_completo varchar(50) not null)
declare @tbOrderRA table(orderid int, RA int)
declare @orderid int = -2147483648, @shippostalcode char(3)

-- Inserindo RAs
insert into @tbRA values	(2103142, 'Luis Antonio dos Santos Junior')
							, (2102167, 'Igor de Moura Artico')
							, (2102829, 'Isabella Gonçalves dos Santos')


-- Varrendo Tabela de Pedidos
while exists(select * from Sales.Orders where orderid > @orderid)
begin
	-- Pegando valores para comparacao
	select @orderid = min(orderid) from Sales.Orders where orderid > @orderid
	select @shippostalcode = right(shippostalcode, 3) from Sales.Orders where orderid = @orderid
	
	-- Verificando Existencia de RAs com mesmo final de SHIPPOSTALCODE 
	if exists (select * from @tbRA where nullif(@shippostalcode, right(cast(RA as char(7)), 3)) is null)
	begin
		insert	@tbOrderRA 
		select	@orderid, RA from @tbRA 
		where	nullif(@shippostalcode, right(cast(RA as char(7)), 3)) is null
	end
end

-- JOIN FINAL
select	a.orderid, a.shippostalcode, b.RA, c.nome_completo 
from	Sales.Orders as a	inner join @tbOrderRA as b on a.orderid = b.orderid 
							inner join @tbRA as c on b.RA = c.RA

