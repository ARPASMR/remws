create table servers
(
    id integer not null auto_increment primary key,
    machine varchar(50) not null,
    ip varchar(18) not null,
    is_master bool not null default false
)