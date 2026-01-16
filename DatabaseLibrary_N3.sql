--Criando Tabelas
CREATE TABLE livros (
    book_id INT IDENTITY(1,1) PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100) NOT NULL,
    genre VARCHAR(50) NOT NULL,
    published_year INT NOT NULL
)

CREATE TABLE usuarios (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE
)

CREATE TABLE emprestimos (
    loan_id INT IDENTITY(1,1) PRIMARY KEY,
    book_id INT NOT NULL,
    user_id INT NOT NULL,
    loan_date DATE NOT NULL,
    return_date DATE,

    CONSTRAINT fk_loans_books 
        FOREIGN KEY (book_id) REFERENCES livros(book_id),

    CONSTRAINT fk_loans_users 
        FOREIGN KEY (user_id) REFERENCES usuarios(user_id)
)
--Necessário criar regra para não aceitar que o mesmo livro seja emprestado estando emprestado
CREATE UNIQUE INDEX uq_loans_book_active
ON emprestimos (book_id)
WHERE return_date IS NULL

-- Inserindo valores na tabela dos livros
INSERT INTO livros (title, author, genre, published_year) VALUES
('1984','George Orwell','Distopia',1949),
('Animal Farm','George Orwell','Sátira Política',1945),
('Brave New World','Aldous Huxley','Distopia',1932),
('Fahrenheit 451','Ray Bradbury','Distopia',1953),
('The Hobbit','J.R.R. Tolkien','Fantasia',1937),
('The Lord of the Rings','J.R.R. Tolkien','Fantasia',1954),
('Harry Potter and the Sorcerer''s Stone','J.K. Rowling','Fantasia',1997),
('Harry Potter and the Chamber of Secrets','J.K. Rowling','Fantasia',1998),
('The Catcher in the Rye','J.D. Salinger','Ficção',1951),
('To Kill a Mockingbird','Harper Lee','Ficção',1960),
('The Great Gatsby','F. Scott Fitzgerald','Clássico',1925),
('Moby Dick','Herman Melville','Clássico',1851),
('Pride and Prejudice','Jane Austen','Romance',1813),
('Jane Eyre','Charlotte Brontë','Romance',1847),
('Wuthering Heights','Emily Brontë','Romance',1847),
('The Da Vinci Code','Dan Brown','Suspense',2003),
('Angels & Demons','Dan Brown','Suspense',2000),
('The Alchemist','Paulo Coelho','Ficção',1988),
('The Little Prince','Antoine de Saint-Exupéry','Fábula',1943),
('Crime and Punishment','Fyodor Dostoevsky','Clássico',1866),
('The Brothers Karamazov','Fyodor Dostoevsky','Clássico',1880),
('War and Peace','Leo Tolstoy','História',1869),
('The Hitchhiker''s Guide to the Galaxy','Douglas Adams','Ficção Científica',1979),
('Dune','Frank Herbert','Ficção Científica',1965),
('Foundation','Isaac Asimov','Ficção Científica',1951),
('The Shining','Stephen King','Horror',1977),
('It','Stephen King','Horror',1986),
('Dracula','Bram Stoker','Horror',1897),
('Frankenstein','Mary Shelley','Horror',1818),
('The Road','Cormac McCarthy', 'Pós-Apocalipse',2006)

--Conferindo valores em livros
SELECT * FROM livros

--Inserindo valores em usuários
INSERT INTO usuarios (name, email) VALUES
('Ana Souza','ana.souza@email.com'),
('Bruno Lima','bruno.lima@email.com'),
('Carla Mendes','carla.mendes@email.com'),
('Diego Rocha','diego.rocha@email.com'),
('Elisa Torres','elisa.torres@email.com'),
('Fernando Alves','fernando.alves@email.com'),
('Gabriela Pacheco','gabriela.pacheco@email.com'),
('Henrique Costa','henrique.costa@email.com'),
('Isabela Moura','isabela.moura@email.com'),
('João Ribeiro','joao.ribeiro@email.com'),
('Karen Silva','karen.silva@email.com'),
('Lucas Andrade','lucas.andrade@email.com'),
('Marina Lopes','marina.lopes@email.com'),
('Nelson Barros','nelson.barros@email.com'),
('Paula Freitas','paula.freitas@email.com'),
('Rafael Nogueira','rafael.nogueira@email.com'),
('Sabrina Azevedo','sabrina.azevedo@email.com'),
('Tiago Moreira','tiago.moreira@email.com'),
('Vanessa Farias','vanessa.farias@email.com'),
('William Teixeira','william.teixeira@email.com')

--Conferindo os dados de usuarios 
SELECT * FROM usuarios

--Inserindo dados em emprestimos
INSERT INTO emprestimos (book_id, user_id, loan_date, return_date) VALUES
(7, 5,  '2025-01-04', '2025-01-07'),
(12, 8,  '2025-01-06', NULL),
(13, 12, '2025-01-09', '2025-01-12'),
(24, 3,  '2025-01-11', NULL),
(15, 15, '2025-01-14', '2025-01-17'),
(26, 2,  '2025-02-02', NULL),
(4, 10, '2025-02-04', '2025-02-07'),
(25, 6,  '2025-02-06', NULL),
(28, 14, '2025-02-08', '2025-02-11'),
(27,1,  '2025-02-10', NULL),
(21,9,  '2025-03-01', '2025-03-04'),
(17,4,  '2025-03-03', NULL),
(11,7,  '2025-03-06', '2025-03-09'),
(19,11, '2025-03-08', NULL),
(29,13, '2025-03-11', '2025-03-14')

--Conferindo os dados de emprestimos 
SELECT * FROM emprestimos

--Adicionando novos livros ao catálogo
INSERT INTO livros (title, author, genre, published_year) VALUES
('Vidas Secas', 'Graciliano Ramos', 'Romance Moderno', '1938')
INSERT INTO livros (title, author, genre, published_year) VALUES
('Dom Casmurro', 'Machado de Assis', 'Romance', '2015')

--Inserir empréstimo para testar a condição
INSERT INTO emprestimos (book_id, user_id, loan_date)
VALUES (1, 2, '2025-02-01')

INSERT INTO Loans (book_id, user_id, loan_date)
VALUES (1, 3, '2025-02-02')

--Atualizando informações do livro existente
UPDATE livros
SET published_year = '2024'
WHERE book_id = 31

--Atualizando várias informações
UPDATE livros
SET   genre = 'Ficção'
      published_year = 2020
WHERE book_id = 30

--Criando Procedimento para deletar um livro, para emitir msg de quando não deletar
CREATE PROCEDURE sp_excluir_livro
    @book_id INT     --identificar o livro
AS
BEGIN
    SET NOCOUNT ON   --evitar mensagens automáticas das linhas afetadas

    -- Verificar se o livro está emprestado
    IF EXISTS (
        SELECT 1       --começa pela linha 1
        FROM emprestimos
        WHERE book_id = @book_id
          AND return_date IS NULL
    )
    BEGIN
        RAISERROR ('Livro está emprestado e não pode ser excluído.', 16, 1) --severidade 16 indica erro tratável em bd e estado
        RETURN
    END

    -- Excluir histórico de empréstimos
    DELETE FROM emprestimos
    WHERE book_id = @book_id

    -- Excluir o livro
    DELETE FROM livros
    WHERE book_id = @book_id

    PRINT 'Livro excluído com sucesso.'
END

--Executar o procedimento de excluir livro selecionando o livro
EXEC sp_excluir_livro @book_id = 26


--Buscar livros no catálogo
SELECT * FROM livros
WHERE title = 'War and Peace'

SELECT * FROM livros
WHERE author = 'J.K. Rowling'

SELECT * FROM livros
WHERE author = 'Machado de Assis' AND title = 'Dom Casmurro'

--Adicionar novos usuários
INSERT INTO usuarios (name,email) VALUES 
    ('João Souza','esseejoaos@gmail.com')

INSERT INTO usuarios (name,email) VALUES 
    ('Joaquina Souza','esseejoaquinas@gmail.com')

--Mudando informações de usuários
UPDATE usuarios
SET name = 'Henrique Matheus da Costa'
WHERE user_id = 8

UPDATE usuarios
SET email = 'nelson.barros@hotmail.com'
WHERE user_id = 14

--Excluir usuários

--Criar procedimento para excluir usuário, pois função não aceita
CREATE PROCEDURE sp_excluir_usuario
    @user_id INT  --parâmetro para identificar o usuário
AS
BEGIN
    SET NOCOUNT ON --evita mensagens automáticas das linhas afetadas

    IF EXISTS (     --verifica se o usuário possui empréstimo ativo
        SELECT 1
        FROM emprestimos
        WHERE user_id = @user_id
          AND return_date IS NULL
    )
    BEGIN                   --caso empréstimo ativo ele vai emitir uma mensagem
        RAISERROR ('Usuário possui empréstimo ativo e não pode ser excluído.', 16, 1)  --severidade 16 da mensagem indica um erro tratável e 1 é o estado
        RETURN
    END
    
--deleta das tabelas que possuem o usuário
    DELETE FROM emprestimos 
    WHERE user_id = @user_id

    DELETE FROM usuarios
    WHERE user_id = @user_id

    PRINT 'Usuário excluído com sucesso.' 
END

--Executar o procedimento para excluir, digitando somente o id do usuário
EXEC sp_excluir_usuario @user_id = 12

--Buscar usuários por nome ou email
SELECT * FROM usuarios
WHERE name = 'Ana Souza'

SELECT * FROM usuarios
WHERE email = 'carla.mendes@email.com'

--EMPRÉSTIMO DE LIVROS

--Criar Procedimento para empréstimo de livros
CREATE PROCEDURE sp_emprestar_livro
    @book_id INT,     -- Recebe o ID do livro a ser emprestado
    @user_id INT,     -- Recebe o ID do usuário
    @loan_date DATE   -- Recebe a data do empréstimo
AS
BEGIN
    SET NOCOUNT ON   -- Evita mensagens de "linhas afetadas"

    -- Verifica se o livro já possui um empréstimo ativo
    -- Empréstimo ativo é aquele cuja data de retorno é NULL
    IF EXISTS ( 
        SELECT 1
        FROM emprestimos
        WHERE book_id = @book_id
          AND return_date IS NULL
    )
    BEGIN
        -- Gera erro caso o livro já esteja emprestado
        RAISERROR ('Livro já está emprestado.', 16, 1) --A mensagem e o número 16 indica erro tratável em DB e 1 o estado
        RETURN -- Interrompe a execução da procedure
    END
  -- Insere um novo registro de empréstimo caso não possua empréstimo
    INSERT INTO emprestimos (book_id, user_id, loan_date)
    VALUES (@book_id, @user_id, @loan_date)

    -- Mensagem de confirmação
    PRINT 'Empréstimo realizado com sucesso.' --emite a mensagem de sucesso
END

--Inserindo um novo empréstimo
EXEC sp_emprestar_livro
    @book_id = 21,
    @user_id = 3,
    @loan_date = '2025-11-15'
    
--Criar procedure para devolução de livros
CREATE PROCEDURE sp_devolver_livro
    @book_id INT   -- Recebe o ID do livro a ser devolvido
AS
BEGIN
    SET NOCOUNT ON -- Evita mensagens automáticas do SQL Server

    -- Verifica se existe um empréstimo ativo para o livro informado
    IF NOT EXISTS (
        SELECT 1    --Começa a varrer da linha 1 de empréstimos
        FROM emprestimos  
        WHERE book_id = @book_id
          AND return_date IS NULL
    )
    BEGIN
        -- Caso não exista empréstimo ativo, gera erro
        RAISERROR ('Não existe empréstimo ativo para este livro.', 16, 1);
        RETURN -- Encerra a execução caso não tenha empréstimo
    END

    -- Atualiza o empréstimo ativo, registrando a data de devolução
    UPDATE emprestimos
    SET return_date = GETDATE() -- Recebe a data atual do sistema
    WHERE book_id = @book_id
      AND return_date IS NULL

    -- Mensagem de confirmação
    PRINT 'Livro devolvido com sucesso.'
END

--Executar a devolução
EXEC sp_devolver_livro
    @book_id = 2    --Se executar duas vezes vai aparecer a mensagem de erro, pois o livro já foi devolido
    
  
--Criar procedimento para consultar se o livro está disponível por nome e id
CREATE PROCEDURE sp_verificar_disponibilidade_livro
    @book_id INT = NULL,            -- Pode receber o ID do livro
    @title   VARCHAR(200) = NULL    -- Ou o título do livro
AS
BEGIN
    SET NOCOUNT ON

    -- Verifica se ao menos um parâmetro foi informado
    IF @book_id IS NULL AND @title IS NULL
    BEGIN
        RAISERROR ('Informe o ID ou o título do livro.', 16, 1)   --Emite mensagem de erro tratável caso o usuário não digite nada
        RETURN
    END

    -- Consulta do livro com verificação de disponibilidade
    SELECT
        l.book_id,
        l.title,
        CASE
            WHEN EXISTS (
                SELECT 1
                FROM emprestimos e
                WHERE e.book_id = e.book_id
                  AND e.return_date IS NULL
            )
            THEN 'INDISPONÍVEL'
            ELSE 'DISPONÍVEL'
        END AS disponibilidade
    FROM livros l
    WHERE (l.book_id = @book_id OR @book_id IS NULL)
      AND (l.title LIKE '%' + @title + '%' OR @title IS NULL)
END

--Testando a procedure
EXEC sp_verificar_disponibilidade_livro
    @title = 'Dom Casmurro'
    
EXEC sp_verificar_disponibilidade_livro
    @book_id= 32
    
--CRIANDO RELATÓRIOS
    
--Livros Emprestados e Devolvidos

SELECT
    e.loan_id,
    l.title,
    u.name AS usuario,
    e.loan_date,
    e.return_date,
    CASE
        WHEN e.return_date IS NULL THEN 'EMPRESTADO'
        ELSE 'DEVOLVIDO'
    END AS status
FROM emprestimos e
JOIN livros l ON e.book_id = l.book_id     --Juntar as tabelas para criar o relatório com as informações do id dos livros e título equivalente que não tem na tabela de empréstimo
JOIN usuarios u ON e.user_id = u.user_id   --Juntar as tableas do id de usuário para colocar os nomes dos usuários que não tem na tabela de empréstimo, formando uma nova tabela
ORDER BY e.loan_date DESC     --ordenar segundo data de empréstimo mais novo para mais antigo

--Relatório dos Livros Emprestados

SELECT l.title, 
       u.name AS usuario,
       e.loan_date
FROM emprestimos e
JOIN livros l ON e.book_id = l.book_id
JOIN usuarios u ON e.user_id = u.user_id
WHERE e.return_date IS NULL

--Relatório de usuários com mais empréstimos

--Criando a Função para somar o total de empréstimos por cliente
CREATE FUNCTION Totalemprestimos 
(@user_id INT)
RETURNS INT
AS
BEGIN
	DECLARE @total_e INT
	
    SELECT @total_e = COUNT(*) 
    FROM emprestimos 
    WHERE user_id = @user_id
    
    RETURN @total_e
END

--Visualizar o relatório em ordem decrescente dos usuários que possuem maior número de empréstimos 
--usando a função Totalemprestimos
SELECT 
    u.user_id,
    u.name,
    dbo.Totalemprestimos(u.user_id) AS total_emprestimos
FROM usuarios u
WHERE dbo.Totalemprestimos(user_id) >= 3
ORDER BY total_emprestimos DESC
