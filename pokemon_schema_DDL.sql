use pokemon_game;

DROP TABLE IF EXISTS poke_dex;
CREATE TABLE poke_dex (
    monster_id INT PRIMARY KEY COMMENT '도감 번호',
    monster_name VARCHAR(10) NOT NULL,
    monster_type VARCHAR(10) NOT NULL COMMENT '원소 속성 /특성',
    max_hp INT NOT NULL,
    evolution_stage INT DEFAULT 1 NOT NULL COMMENT '진화 단계 (1~3)',
    evolves_from INT NULL COMMENT '진화 전 형태',
    is_legendary BOOL DEFAULT FALSE,
    INDEX idx_monstertype (monster_type),
    FOREIGN KEY fk_evolvesfrom (evolves_from) references poke_dex (monster_id),
    CONSTRAINT chk_evolutionstage_range CHECK ( evolution_stage BETWEEN 1 AND 3)
);

DROP TABLE IF EXISTS pokemon_skills;
CREATE TABLE pokemon_skills ( -- 단복수 일관성을 떼는 Entity 가 있다면 수정 필요
    id INT PRIMARY KEY AUTO_INCREMENT,
    skill_name VARCHAR(20) NOT NULL, -- 컬럼명이 사용되는 맥락을 고려했을 때, 충분한 설명이 필요한 경우 , prefix,postfix 사용을 고려
    skill_effect VARCHAR(20) NOT NULL,
    skill_type VARCHAR(10) NOT NULL,
    skill_damage VARCHAR(10) NOT NULL
);

DROP TABLE IF EXISTS pokemon_trainer;
CREATE TABLE pokemon_trainer (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20),
    trainer_type VARCHAR(20) COMMENT '몬스터 타입을 추종하는 트레이너 속성',
    -- FK에 대한 네이밍 컨벤션 지정 => DBA 가 좋아한다
    FOREIGN KEY fk_trainerytpe_monstertype (trainer_type) references poke_dex(monster_type)
);

DROP TABLE IF EXISTS pokemon;
CREATE TABLE pokemon (
    id INT PRIMARY KEY AUTO_INCREMENT,
    monster_id INT NOT NULL,
    skill1 INT NOT NULL,
    skill2 INT NULL,
    owner INT NULL COMMENT '소유자(트레이너), 야생 포켓몬의 경우 NULL',
    nickname VARCHAR(20) NOT NULL,
    hp INT NOT NULL,
    is_surfable BOOLEAN DEFAULT FALSE,
    is_flyable BOOLEAN DEFAULT FALSE,
    -- 한번 정한 DB 객체 (FK, IDX .. etc) 네이밍 컨벤션을 일관해야 함
    FOREIGN KEY fk_pokemon_pokedex (monster_id) references poke_dex (monster_id),
    FOREIGN KEY fk_pokemon_skill1 (skill1) references pokemon_skills (id),
    FOREIGN KEY fk_pokemon_skill2 (skill1) references pokemon_skills (id),
    FOREIGN KEY fk_pokemon_trainer (skill1) references pokemon_trainer (id)
);

DROP TABLE IF EXISTS pokemon_skills;
CREATE TABLE battle_reuslt (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pokemon_id_1 INT NOT NULL,
    pokemon_id_2 INT NOT NULL,
    winner_id INT NULL,
    -- process_log VARCHAR(255)
    result_memo VARCHAR(50)
);
