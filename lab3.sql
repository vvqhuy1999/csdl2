use QLDA;


--Bai 1 a. Với mỗi đề án, liệt kê tên đề án và tổng số giờ làm việc một tuần của tất cả các nhân viên tham dự đề án đó.

-- Bai 1 a.1 Xuất định dạng “tổng số giờ làm việc” kiểu decimal với 2 số thập phân.
declare @TbsumTGD table  (mada int, tenda nvarchar(50) , sumTG float )
insert into @TbsumTGD 
select pc.mada, da.TENDEAN, sum(pc.THOIGIAN)
from PHANCONG pc 
join DEAN da on pc.MADA = da.MADA
group by pc.MADA, da.TENDEAN;

select mada, tenda, cast(sumTG as decimal(6,2)) from @TbsumTGD;

-- Bai 1 a.2 Xuất định dạng “tổng số giờ làm việc” kiểu varchar
declare @TbsumTGV table  (mada int, tenda nvarchar(50) , sumTG float )
insert into @TbsumTGV 
select pc.mada, da.TENDEAN, sum(pc.THOIGIAN)
from PHANCONG pc 
join DEAN da on pc.MADA = da.MADA
group by pc.MADA, da.TENDEAN;

select mada, tenda, cast(sumTG as varchar(10)) from @TbsumTGV;

-- Bai 1 b Với mỗi phòng ban, liệt kê tên phòng ban và lương trung bình của những nhân viên làm
-- việc cho phòng ban đó.
-- Bai 1 b.1 Xuất định dạng “luong trung bình” kiểu decimal với 2 số thập phân, sử dụng dấu
-- phẩy để phân biệt phần nguyên và phần thập phân.

-- @TBLTBD  table luong trungbinh  decimal
declare @TBLTBD table (tenphg nvarchar(20), LTB float)
insert into @TBLTBD
select pb.TENPHG , AVG(nv.LUONG)
from NHANVIEN nv
join PHONGBAN pb on nv.PHG = pb.MAPHG
group by  pb.TENPHG , nv.PHG ;

select tenphg, replace(convert(decimal(8,2),ltb), '.',',')  from @TBLTBD;

 -- select tenphg, FORMAT(LTB,'#,##0,00') from @TBLTBD;

-- Bai 1 b.2 Xuất định dạng “luong trung bình” kiểu varchar. Sử dụng dấu phẩy tách cứ mỗi 3
-- chữ số trong chuỗi ra, gợi ý dùng thêm các hàm Left, Replace

-- @TBLTBV  table luong trungbinh  varchar
declare @TBLTBV table (tenphg nvarchar(20), LTB float)
insert into @TBLTBV
select pb.TENPHG , AVG(nv.LUONG)
from NHANVIEN nv
join PHONGBAN pb on nv.PHG = pb.MAPHG
group by  pb.TENPHG , nv.PHG ;

select tenphg,CAST (FORMAT(LTB, '###,##0') as varchar(10))  from @TBLTBV;


-- Bai 2 1 Với mỗi đề án, liệt kê tên đề án và tổng số giờ làm việc một tuần của tất cả các nhân viên
-- tham dự đề án đó.
-- Bai 2 1.1  Xuất định dạng “tổng số giờ làm việc” với hàm CEILING
declare @TbsumTGCELING table  (mada int, tenda nvarchar(50) , sumTG float )
insert into @TbsumTGCELING 
select pc.mada, da.TENDEAN, sum(pc.THOIGIAN)
from PHANCONG pc 
join DEAN da on pc.MADA = da.MADA
group by pc.MADA, da.TENDEAN;

select mada, tenda, CEILING(sumTG) from @TbsumTGCELING;

-- Bai 2 1.2 Xuất định dạng “tổng số giờ làm việc” với hàm FLOOR
declare @TbsumTGFLOOR table  (mada int, tenda nvarchar(50) , sumTG float )
insert into @TbsumTGFLOOR 
select pc.mada, da.TENDEAN, sum(pc.THOIGIAN)
from PHANCONG pc 
join DEAN da on pc.MADA = da.MADA
group by pc.MADA, da.TENDEAN;

select mada, tenda, floor(sumTG) from @TbsumTGFLOOR;

-- Bai 2 1.3 Xuất định dạng “tổng số giờ làm việc” làm tròn tới 2 chữ số thập phân
declare @TbsumTGROUND table  (mada int, tenda nvarchar(50) , sumTG float )
insert into @TbsumTGROUND 
select pc.mada, da.TENDEAN, sum(pc.THOIGIAN)
from PHANCONG pc 
join DEAN da on pc.MADA = da.MADA
group by pc.MADA, da.TENDEAN;

select mada, tenda, round(sumTG,2) from @TbsumTGROUND;

-- Bai 2 2 Cho biết họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương trên mức lương
-- trung bình (làm tròn đến 2 số thập phân) của phòng "Nghiên cứu"
declare @LuongAVG float;
select @LuongAVG= round(AVG(LUONG),2)
from NHANVIEN nv join PHONGBAN pb on nv.PHG = pb.MAPHG
group by nv.PHG ,pb.TENPHG
having pb.TENPHG = N'Nghiên cứu';

select CONCAT(HONV,' ', TENLOT,' ', TENNV)
from NHANVIEN
where LUONG > @LuongAVG;

-- Bai 3.1 Danh sách những nhân viên (HONV, TENLOT, TENNV, DCHI) có trên 2 thân nhân, thỏa các yêu cầu

-- Bai 3.1.1 Dữ liệu cột HONV được viết in hoa toàn bộ
select UPPER(honv) from NHANVIEN;
-- Bai 3.1.2 Dữ liệu cột TENLOT được viết chữ thường toàn bộ
select LOWER(TENLOT) from NHANVIEN;
-- Bai 3.1.3 Dữ liệu chột TENNV có ký tự thứ 2 được viết in hoa, các ký tự còn lại viết
-- thường( ví dụ: kHanh)
SELECT STUFF(LOWER(TENNV), 2, 1, UPPER(SUBSTRING(TENNV, 2, 1))) FROM nhanvien;

-- Bai 3.1.4 Dữ liệu cột DCHI chỉ hiển thị phần tên đường, không hiển thị các thông tin khác
-- như số nhà hay thành phố.
declare @chisoSpace table (manv nvarchar(15), so int)
insert into @chisoSpace
select MANV,CHARINDEX(' ', DCHI)FROM NHANVIEN

SELECT  substring(dchi,so,CHARINDEX(',', DCHI) - so)
FROM NHANVIEN nv join @chisoSpace cs on nv.MANV = cs.manv

-- Bai 3.2 Cho biết tên phòng ban và họ tên trưởng phòng của phòng ban có đông nhân viên nhất,
-- hiển thị thêm một cột thay thế tên trưởng phòng bằng tên “Fpoly”
declare @fpoly table (ten nvarchar(10))
insert into @fpoly (ten) values('Fpoly');

declare @TenPHGSoNV table (tenphg nvarchar(50), sonv int, matrphg nvarchar(15))
insert into @TenPHGSoNV
select pb.TENPHG, COUNT(nv.PHG) as SoNV, pb.TRPHG
from NHANVIEN nv join PHONGBAN pb on nv.PHG = pb.MAPHG
group by nv.PHG,pb.TENPHG , pb.TRPHG

select slphg.tenphg, CONCAT(nv.HONV,' ',nv.TENLOT,' ', nv.TENNV) as HoTen ,ten
from @fpoly, nhanvien nv
join @TenPHGSoNV slphg on nv.MANV = slphg.matrphg
where slphg.matrphg >=(select max(matrphg) from @TenPHGSoNV)

-- Bai 4
-- Bai4.1 Cho biết các nhân viên có năm sinh trong khoảng 1960 đến 1965.
select HONV,TENLOT,TENNV,NGSINH from NHANVIEN where YEAR(NGSINH) > 1960 and YEAR(NGSINH) < 1965
-- Bai4.2 Cho biết tuổi của các nhân viên tính đến thời điểm hiện tại.
select HONV,TENLOT,TENNV,NGSINH, year(GETDATE()) - YEAR(NGSINH) as Tuoi from NHANVIEN  
-- Bai4.3 Dựa vào dữ liệu NGSINH, cho biết nhân viên sinh vào thứ mấy.
select HONV,TENLOT,TENNV,NGSINH, DATENAME(WEEKDAY,NGSINH) from NHANVIEN
-- Bai4.4 Cho biết số lượng nhân viên, tên trưởng phòng, ngày nhận chức trưởng phòng và ngày
-- nhận chức trưởng phòng hiển thi theo định dạng dd-mm-yy (ví dụ 25-04-2019)
declare @tbTPSL table ( sonv int, matrphg nvarchar(15), ng_nhanchuc date)
insert into @tbTPSL
select COUNT(nv.PHG) as SoNV, pb.TRPHG , pb.NG_NHANCHUC
from NHANVIEN nv join PHONGBAN pb on nv.PHG = pb.MAPHG
group by nv.PHG,pb.TENPHG , pb.TRPHG, pb.NG_NHANCHUC

select CONCAT(nv.HONV,' ',nv.TENLOT,' ', nv.TENNV) as HoTen ,
TPSL.sonv , TPSL.ng_nhanchuc, CONVERT(varchar,TPSL.ng_nhanchuc,103)
from  nhanvien nv
join @tbTPSL TPSL on nv.MANV = TPSL.matrphg
