--- Creacion de Base de Datos----
Create database consultas;
go
use consultas;

---- Creacion de Tablas --------
Create table Empleados (
idEmpleado INT primary key identity (100000,1) not null,
NombreEmpleado varchar (45) not null,
ApellidoEmpleado varchar(45) null,
Puesto varchar(45) not null,
FechaIngreso datetime not null

);

Create table CentrosTrabajo (
idCentro int primary key identity (100000,1) not null,
Nombre varchar (45) not null,
Ubicacion varchar (100)not null
);

Create table Planificacion (
idPlanificacion int primary key identity (10000,1) not null,
idEmpleado int foreign key references Empleados (idEmpleado),
idCentro int foreign key references CentrosTrabajo (idCentro),
Fecha datetime not null,
HorasPlanificadas int not null
);

Create table Asistencia (
idAsistencia int primary key identity (12102,1) not null,
idEmpleado int foreign key references Empleados (idEmpleado),
idCentro int foreign key references CentrosTrabajo (idCentro),
Fecha datetime not null,
HorasLaboradas int not null
);

--- Insertar datos como ejemplo----

insert into Empleados (NombreEmpleado, ApellidoEmpleado, Puesto, FechaIngreso)
values
('Juan', 'Perez', 'Analista', '2022-01-15'),
('Maria','López','Desarrollador','2021-03-10'),
('Carlos','Ramirez','Supervisor','2020-07-01'),
('Ana', 'Gómez', 'Diseñadora', '2023-05-20'),
('Luis', 'Martínez', 'Contador', '2019-11-02'),
('Sofía', 'Hernández', 'Recursos Humanos', '2024-02-14');

insert into CentrosTrabajo (Nombre,Ubicacion)
values
('Centro Norte','Zona 1, Ciudad de Guatemala'),
('Centro Sur', 'Zona 12, Ciudad de Guatemala'),
('Centro Este', 'Zona 5, Ciudad de Guatemala'),
('Centro Oeste', 'Mixco, Guatemala');


insert into Planificacion (idEmpleado, idCentro,Fecha,HorasPlanificadas)
values
(100000, 100000, '2026-04-01',8), --- Juan > Centro Norte
(100001,100000,'2026-04-01',6), --- Maria > Centro Norte
(100002,100001,'2026-04-01',8), ---- Carlos > Centro Centro Sur
(100003, 100002, '2026-04-01', 7), --- Ana > Centro Este
(100004, 100000, '2026-04-01', 8),   --- Luis >  Centro Norte
(100005, 100001, '2026-04-01', 6);  --- Sofia >  Centro Sur


insert into Asistencia (idEmpleado,idCentro,Fecha,HorasLaboradas)
values
(100000,100000, '2026-04-01',8),
(100001,100000,'2026-04-01',4),
(100002,100001,'2026-04-01',10),
(100003, 100002, '2026-04-01', 7), 
(100004, 100000, '2026-04-01', 9), 
(100005, 100001, '2026-04-01', 5);  

--- Consultas---

Select c.Nombre As CentroTrabajo,
Sum(a.HorasLaboradas) as TotalHoras
From Asistencia a
Inner Join CentrosTrabajo c on a.idCentro = c.idCentro
where month (a.Fecha) = 4 and year (a.Fecha) = 2026
group by c.Nombre
Order by TotalHoras Desc;

Select
c.Nombre As CentroTrabajo,
e.NombreEmpleado,
Count (p.idPlanificacion) - count (a.idAsistencia) as Inasistencias
From Planificacion p
Inner Join Empleados e on p.idEmpleado = e.idEmpleado
Inner Join CentrosTrabajo c on p.idCentro = c.idCentro
left join Asistencia a
on p.idEmpleado = a.idEmpleado
and p.idCentro = a.idCentro
and p.Fecha = a.Fecha
where month (p.Fecha) = 4 and year (p.Fecha) = 2026
group by c.Nombre, e.NombreEmpleado
order by Inasistencias Desc;

Select e.NombreEmpleado,
Sum (a.HorasLaboradas - p.HorasPlanificadas) as HorasExtras
From Asistencia a
Join Planificacion p
on a.idEmpleado = p.idEmpleado
and a.Fecha = p.Fecha
Join Empleados e on a.idEmpleado = e.idEmpleado
group by e.NombreEmpleado;