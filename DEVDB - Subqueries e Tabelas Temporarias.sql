-----------------------------------------------------------------------------------------------
-- EXERCÍCIOS
-----------------------------------------------------------------------------------------------

-- 1) Listar as VendasAnuais onde o valor do Veiculo seja o valor R$ 28.011,00 (autosuficiente).
select * from Veiculo order by valor desc -- 59

Select 	*
From  	VendasAnuais 
Where 	idVeiculo = (
					select	idVeiculo
					from	Veiculo
					where	valor = 28011.00
					)

-- Por Join					
Select 	VA.*
From  	VendasAnuais as VA	inner join Veiculo as V
						on V.idVeiculo = VA.idVeiculo
where 	V.valor = 28011.00



-- 2. Listar os Fabricantes cujos veículos obtiveram soma da quantidade de vendas acima de 7.500 unidades (correlacionada).
select * from Fabricante
select * from Veiculo
select * from VendasAnuais

Select 	*
From  	Fabricante 
Where	idFabricante in (
						select V.idFabricante
						from  	Veiculo as V 
						where	V.idVeiculo in	(
												select	idVeiculo
												from	VendasAnuais 
												where	idVeiculo = V.idVeiculo
												group by idVeiculo
												having sum(qtd) >= 7500 
												)
						)

-- Por Join
select	V.idVeiculo, V.Descricao as 'Veículo', M.Descricao as 'Modelo', F.nome as Fabricante, sum(qtd) as 'Soma de Quantidade Vedida'
From  	VendasAnuais VA	inner join Veiculo V on V.idVeiculo = VA.idVeiculo 
						inner join Fabricante F on V.idFabricante = F.idFabricante
						inner join Modelo as M on V.idModelo = M.idmodelo
group by V.idVeiculo, V.Descricao, M.Descricao, F.nome
having sum(qtd) >= 7500
order by 'Soma de Quantidade Vedida' desc





-- 3) Traga as descrições dos veículos e valores distintos que existam (EXISTS) o modelo GS.
select * from Modelo
select * from Veiculo where idModelo = 1

Select 	distinct descricao, idModelo, valor
From  	Veiculo
Where 	exists	(
				select 	*
				from 	Modelo
				where 	Descricao = 'GS'
						and Modelo.idModelo = Veiculo.idModelo
				)

-- 4) Traga as descrições dos veículos distintos que NÃO existam (NOT EXISTS) os modelos R, STD e GTR.
select * from Modelo
select distinct descricao from Veiculo where idModelo not in (2, 7, 5)

Select 	distinct descricao
From  	Veiculo
Where 	NOT EXISTS	(
					select 	*
					from 	Modelo
					where 	Descricao IN ('R', 'STD', 'GTR')
						and Modelo.idModelo = Veiculo.idModelo
					)

-- 5) Crie uma tabela temporária LOCAL com o nome, endereço e contato dos
--  Fabricantes do sudeste. Teste o acesso em outra conexão.
select * from fabricante

Select 	nome, endereco, contato
Into 	#tempLocal
From  	Fabricante
Where 	uf in ('SP', 'RJ', 'MG', 'ES')

select * from #tempLocal


-- 6) Crie uma tabela temporária GLOBAL com a descrição e valor dos veículos 
-- onde a descrição no qual o Fabricante seja Honda. Teste o acesso em outra conexão.
Select 	descricao, valor
Into 	##tempGlobal
From  	Veiculo
Where 	idFabricante =	(
						select idFabricante from Fabricante 
						where nome = 'Honda'
						)

select * from ##tempGlobal



