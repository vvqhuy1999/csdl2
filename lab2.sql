use QLDA;

-- Chương trình tính diện tích, chu vi hình chữ nhật khi biết chiều dài và chiều rộng.

declare @dientich float, @Chuvi float

set @dientich = 5 * 3;
set @Chuvi = (5+3) * 2;
print 'Chu vi cua Hinh Chu nhat = ' + cast(@Chuvi as varchar) + ' Dien tich cua Hinh Chu nhat = ' + cast(@dientich as varchar);


-- 1. Cho biêt nhân viên có lương cao nhất
declare @maxluong float;
select @maxluong =max(luong) from NHANVIEN;

print N'Luong nhan vien cao nhat = ' + convert(varchar,@maxluong)

-- 2. Cho biết họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương
-- trên mức lương trung bình của phòng "Nghiên cứu”
/*
declare @luongTBPNC float;

select @luongTBPNC = AVG(luong) 
from NHANVIEN nv 
join PHONGBAN pb on nv.PHG = pb.MAPHG
where pb.TENPHG = N'Nghiên cứu';

select honv, tenlot, tennv from NHANVIEN where LUONG > @luongTBPNC;
*/
declare @ltbPNC table (honv nvarchar(15), tenlot nvarchar(5), tennv nvarchar(15))
declare @ltb float

select @ltb = AVG(luong)
from NHANVIEN nv join PHONGBAN pb on nv.PHG = pb.MAPHG
where pb.TENPHG = N'Nghiên cứu';

insert into @ltbPNC
select honv,tenlot,tennv
from NHANVIEN
where LUONG > @ltb

select * from @ltbPNC;


/*
select * from NHANVIEN;
select * from PHONGBAN;
select * from dean;
*/
-- 3. Với các phòng ban có mức lương trung bình trên 30,000, liệt kê tên
-- phòng ban và số lượng nhân viên của phòng ban đó.

declare @luongtb table (maphg int , avgl float, sl int)

insert into @luongtb
select maphg, avg(LUONG),COUNT(MANV) from NHANVIEN nv
join PHONGBAN pb on nv.PHG = pb.MAPHG
group by MAPHG
having AVG(luong) > 30000

select * from @luongtb;

-- 4. Với mỗi phòng ban, cho biết tên phòng ban và số lượng đề án mà
-- phòng ban đó chủ trì
declare @tb table (maphg int, tenphong nvarchar(20), slda int)

insert into @tb
select pb.MAPHG, pb.TENPHG, count(da.MADA)
from PHONGBAN pb join DEAN da on pb.MAPHG = da.PHONG
group by pb.MAPHG, pb.TENPHG

select * from @tb;

-- Bai tap them
-- 1. Cho biết tên nhân viên và số thân nhân của mỗi nhân viên
declare @tbsltn table (tennv nvarchar(15), sltn int);

insert into @tbsltn
select nv.TENNV, COUNT(tn.MA_NVIEN)
from NHANVIEN nv join THANNHAN tn
on nv.MANV = tn.MA_NVIEN
group by nv.TENNV;

select * from @tbsltn;

-- 2. Cho biết lương trung bình của các Nhân viên Nam
declare @ltbN float;

select @ltbN = AVG(luong)
from NHANVIEN
group by PHAI
having PHAI like 'Nam';

print 'Luong trung binh cua cac nhan vien Nam = ' + convert(varchar,@ltbN);



-- 3. Danh sách Nhân viên : Mã NV, Tên NV chưa được phân công Đề án nào
declare @NVChuaPhanCongDeAN table (manv varchar(5), tennv nvarchar(15));

insert into @NVChuaPhanCongDeAN
select MANV, TENNV
from NHANVIEN nv 
left join PHANCONG pc on nv.MANV = pc.MA_NVIEN
where MA_NVIEN is null;

select * from @NVChuaPhanCongDeAN;


-- 4. Đề án ( Tên Đề án, Tổng THời gian ) có tổng thời gian tham gia của nhân viên nhiều nhất
declare @TongTGDA  table (tenda nvarchar(15), sumTG float);

insert into @TongTGDA
select da.TENDEAN,sum(pc.THOIGIAN) from DEAN da 
join PHANCONG pc on da.MADA = pc.MADA 
group by pc.MADA,da.TENDEAN
having SUM(pc.THOIGIAN) >= all
							(select sum(pc.THOIGIAN)  tongTG from DEAN da 
							join PHANCONG pc on da.MADA = pc.MADA 
							group by pc.MADA) 

select * from @TongTGDA;
