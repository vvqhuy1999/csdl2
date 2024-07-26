/* 1. Thêm thông tin vào các bảng
- Tạo ba Stored Procedure (SP) với các tham số đầu vào phù hợp.
o SP thứ nhất thực hiện chèn dữ liệu vào bảng NGUOIDUNG*/ 
select * from NguoiDung
go
create or alter procedure sp_Insert_NguoiDung
	@MaND int,
	@TenND nvarchar(50),
	@GioiTinh bit,
	@DienThoai nvarchar(12),
	@DiaChi nvarchar(50),
	@Email nvarchar(50)
as
	if(@MaND is null) or (@TenND is null)
		begin
			print N'Lỗi'
			print N'Thiếu thông tin'
		end
	else
		begin
			insert into NguoiDung(MaND,HoTen,GioiTinh,DienThoai,DiaChi,Email)
			values(@MaND,@TenND,@GioiTinh,@DienThoai,@DiaChi,@Email)
			print N'Thêm thành công'
		end
go
exec sp_Insert_NguoiDung 7,'Quang Huy','1','0147896523',N'Q2','LoanNV1741@gmail.com'

/* o SP thứ hai thực hiện chèn dữ liệu vào bảng NHATRO */
go
create or alter procedure sp_insert_NhaTro
		@MaNT char(4),
		@DienTich float,
		@Gia float,
		@DiaChi nvarchar(50),
		@Quan nvarchar(20),
		@MoTa nvarchar(50),
		@NgDangTin date,
		@MaLoai char(4),
		@MaND char(4)
	as begin
		if ((@MaNT is null) or (@DienTich is null) or (@Gia is null) or (@DiaChi is null)
			or (@Quan is null) or (@MoTa is null) or (@NgDangTin is null) or (@MaLoai is null) or (@MaND is null))
			begin
				print N'Vui lòng nhập đầy đủ thông tin !!!'
			end
		else 
			begin
				insert into NhaTro values
				(@MaNT,@DienTich,@Gia,@DiaChi,@Quan,@MoTa,@NgDangTin,@MaLoai,@MaND);
			end
	end 
	go
select * from NhaTro

	-- Thực thi đúng  --
	exec sp_insert_NhaTro 'NT15',89,35000000,N'115 Nguyễn Phúc Thụ',N'Quận 4',N'Đầy đủ tiện nghi','2023-10-14','CHCC','U02'
	-- Thực thi sai --
	exec sp_insert_NhaTro 'NT16',85,15000000,N'921 Đường Nguyễn Trãi',null,N'Đầy đủ tiện nghi','2023-10-14','CHCC','U5'
	go


/*o SP thứ ba thực hiện chèn dữ liệu vào bảng DANHGIA*/
select * from DANHGIA
go
create or alter procedure sp_insertDanhGia 
		@MaND char(5),
		@MaNT char(5),
		@NoiDung nvarchar(50),
		@YeuThich bit
		
	as begin
		if((@MaND is null) or (@MaNT is null) or (@NoiDung is null) or (@YeuThich is null))
			print N'Vui lòng nhập đầy đủ thông tin!!!'
		else 
			begin 
				insert into danhgia values
				(@MaND,@MaNT,@NoiDung,@YeuThich);
			end
	end

	-- Thực thi đúng  --
	exec sp_insertDanhGia 'U02','NT07',N'Phòng kém chất lượng',1
	-- Thực thi sai --
	exec sp_insertDanhGia 'U05','NT08',null,1
	go

	/* 2. Truy Vấn
a. Viết một SP với các tham số đầu vào phù hợp. SP thực hiện tìm kiếm thông tin các
phòng trọ thỏa mãn điều kiện tìm kiếm theo: Quận, phạm vi diện tích, phạm vi ngày đăng
tin, khoảng giá tiền, loại hình nhà trọ.
SP này trả về thông tin các phòng trọ, gồm các cột có định dạng sau:
o Cột thứ nhất: có định dạng ‘Cho thuê phòng trọ tại’ + <Địa chỉ phòng trọ>
+ <Tên quận/Huyện>
o Cột thứ hai: Hiển thị diện tích phòng trọ dưới định dạng số theo chuẩn Việt Nam +
m2. Ví dụ 30,5 m2
o Cột thứ ba: Hiển thị thông tin giá phòng dưới định dạng số theo định dạng chuẩn
Việt Nam. Ví dụ 1.700.000
o Cột thứ tư: Hiển thị thông tin mô tả của phòng trọ
o Cột thứ năm: Hiển thị ngày đăng tin dưới định dạng chuẩn Việt Nam.
Ví dụ: 27-02-2012
o Cột thứ sáu: Hiển thị thông tin người liên hệ dưới định dạng sau:
 Nếu giới tính là Nam. Hiển thị: A. + tên người liên hệ. Ví dụ A. Thắng
 Nếu giới tính là Nữ. Hiển thị: C. + tên người liên hệ. Ví dụ C. Lan
o Cột thứ bảy: Số điện thoại liên hệ
o Cột thứ tám: Địa chỉ người liên hệ
- Viết hai lời gọi cho SP này*/
Create or alter procedure sp_TimTro1 
			@Quan nvarchar(20),
			@DT float,
			@MinGia int,
			@MaxGia int,
			@NgDangTin date,
			@LoaiNT nvarchar(50)
	as begin
		select  N'Cho thuê tại: ' + NT.DiaChi + ' '+ NT.Quan as N'Ðịa chỉ thuê',
				replace(convert(nvarchar,NT.DienTich),'.',',')+'m2' as N'Diện Tích' ,
				replace(format(NT.GiaPhong,'#,##0'),',','.') as N'Giá' ,
				MoTa as N'Mô tả',
				format(ngayDangTin,'dd-MM-yy') as N'Ngày đăng tin',
				(case 
					when GioiTinh = 1 then 'A.'+ HoTen
					else 'C.'+ HoTen
				 end) as N'Người liên lạc',
				 DienThoai as N'Số điện thoại',
				ND.DiaChi as N'Địa chỉ người liên lạc' 
		from NguoiDung ND inner join NhaTro NT  on NT.MaND = ND.MaND inner join LoaiNha LN on LN.MaLoai = NT.MaLoai
		where NT.Quan like (concat('%',@Quan))
			and(DienTich > (@DT - 5)  and DienTich < (@DT + 5))
			and (GiaPhong > @MinGia and GiaPhong <@MaxGia)
			and (NgayDangTin >= @NgDangTin )
			and (TenLoai = @LoaiNT)
	end
	select * from NhaTro
	select * from LoaiNha
-- Thực thi đúng  --
	exec sp_TimTro1 N'Quận 4',89,7000,36000000,'2023-08-09',N'Căn hộ Chung cư'
-- Thực thi sai --
	exec sp_TimTro1 N'Quận 4',42,2000000,6000000,'2023-11-20',N'Nhà thấp'

/* b. Viết một hàm có các tham số đầu vào tương ứng với tất cả các cột của bảng 
NGUOIDUNG. Hàm này trả về mã người dùng (giá trị của cột khóa chính của bảng 
NGUOIDUNG) thỏa mãn các giá trị được truyền vào tham số.*/ 
GO
/* b. Viết một hàm có các tham số đầu vào tương ứng với tất cả các cột của bảng 
NGUOIDUNG. Hàm này trả về mã người dùng (giá trị của cột khóa chính của bảng 
NGUOIDUNG) thỏa mãn các giá trị được truyền vào tham số.*/ 
go
		create or alter function fn_MaNguoiDung (
				@HoTen nvarchar(50) = N'%',
				@GioiTinh bit,
				@DienThoai nvarchar(12) = N'%',
				@DiaChi nvarchar(50) = N'%',
				@Email nvarchar(50) = N'%')
		returns table
		as 
			return
				(select MaND from NguoiDung where HoTen  like @HoTen and
					GioiTinh like @GioiTinh and DiaChi like @DiaChi and
					DienThoai like @DienThoai and Email like @Email)
		go
					
	-- Thực thi --
	select * from  dbo.fn_MaNguoiDung('Quang Huy',1,'0147896523','Q2','LoanNV1741@gmail.com');
	
/*c. Viết hàm có tham số đầu vào là mã nhà trọ (cột khóa chính của bảng NHATRO).
Hàm này trả về tổng số LIKE và DISLIKE của nhà trọ này.*/
go
create or alter function fn_danhgia_Like (@MaNT nvarchar(5))
	returns int
	as 
		begin
			return (select COUNT(*) from DanhGia where MaNT = @MaNT and YeuThich = 1)
	end
go


go
create or alter function fn_danhgia_DisLike (@MaNT nvarchar(5))
	returns int
	as 
		begin
			return (select COUNT(*) from DanhGia where MaNT = @MaNT and YeuThich = 0)
	end
go
print N'Tổng Like: '+ convert(nvarchar, dbo.fn_danhgia_Like('NT01'))
print N'Tổng Like: '+ convert(nvarchar, dbo.fn_danhgia_Like('NT02'))
print N'Tổng DisLike: '+ convert(nvarchar, dbo.fn_danhgia_DisLike('NT01'))
print N'Tổng DisLike: '+ convert(nvarchar, dbo.fn_danhgia_DisLike('NT02'))


/*d. Tạo một View lưu thông tin của TOP 10 nhà trọ có số người dùng LIKE nhiều nhất gồm 
các thông tin sau:
- Diện tích
- Giá
- Mô tả
- Ngày đăng tin
- Tên người liên hệ
- Địa chỉ
- Điện thoại
- Email */
go
create or alter view v_top10_NhaTro 
as
		select top 10
		dbo.fn_danhgia_Like(MaNT) as 'Tong Like',
		format(NT.DienTich ,'#,##,0')+' m2' as N'Diện tích', replace(format(NT.GiaPhong,'#,##0'),',','.') as N'Giá',MoTa as N'Mô tả',
			 format(nt.NgayDangTin,'dd-MM-yy') as N'Ngày đăng tin',ND.HoTen as N'Tên người liên lạc',
			 ND.DiaChi as N'Địa chỉ',ND.DienThoai as N'Điện thoại', ND.Email
		from NhaTro NT inner join NguoiDung ND on NT.MaND = ND.MaND
		order by 'Tong Like' desc 
go

select * from v_top10_NhaTro 

/*e. Viết một Stored Procedure nhận tham số đầu vào là mã nhà trọ (cột khóa chính của
bảng NHATRO). SP này trả về tập kết quả gồm các thông tin sau:
- Mã nhà trọ
- Tên người đánh giá
- Trạng thái LIKE hay DISLIKE
- Nội dung đánh giá */
go
create or alter procedure sp_DanhGia_NhaTro (@MaNT char(5))
as
if not exists (select * from NhaTro where MaNT = @MaNT)
	begin
		print N'Nhà trọ này không tồn tại'
	end
else
	begin
		if not exists (select * from DanhGia where MaNT = @MaNT)
			begin
				print N'Mã nhà trọ này chưa dc đánh giá'
			end
		else
			begin
				select DG.MaNT as 'Mã nhà trọ', ND.HoTen as 'Tên Người Đánh Giá',
					case DG.YeuThich 
						when 1 then 'Like'
						when 0 then 'DisLike'
					end as 'Trạng thái LIKE hay DISLIKE', DG.NoiDung as'Nội dung đánh giá '
				from DanhGia DG inner join NguoiDung ND on ND.MaND = DG.MaND
				where DG.MaNT = @MaNT
			end
end
go
-- Thực thi --
exec sp_DanhGia_NhaTro 'NT03'
go

/* 3. Xóa thông tin
1. Viết một SP nhận một tham số đầu vào kiểu int là số lượng DISLIKE. SP này thực hiện
thao tác xóa thông tin của các nhà trọ và thông tin đánh giá của chúng, nếu tổng số lượng
DISLIKE tương ứng với nhà trọ này lớn hơn giá trị tham số được truyền vào.
Yêu cầu: Sử dụng giao dịch trong thân SP, để đảm bảo tính toàn vẹn dữ liệu khi một thao tác 
xóa thực hiện không thành công. */
create or alter procedure SP_NhatroDisLike @DisLike int
		as 
		begin try
			declare @TbNhaTro table (MaNT int)
			insert into @TbNhaTro
			select MaNT from NhaTro where dbo.fn_DanhGia_DisLike(MaNT)>=@DisLike
			begin tran
				delete from DanhGia where MaNT in (select MaNT from @TbNhaTro)
				delete from NhaTro where MaNT in (select MaNT from @TbNhaTro)
				print N'Đã xóa thành công'
			commit tran
		end try
		begin catch
			rollback tran
			print N'Xóa không thành Công'
		end catch

	-- select MaNT, dbo.fn_DanhGia_DisLike(MaNT) from NhaTro		
	exec SP_NhatroDisLike 1
	exec SP_NhatroDisLike 10


/* 2. Viết một SP nhận hai tham số đầu vào là khoảng thời gian đăng tin. SP này thực hiện
thao tác xóa thông tin những nhà trọ được đăng trong khoảng thời gian được truyền vào 
qua các tham số.
Lưu ý: SP cũng phải thực hiện xóa thông tin đánh giá của các nhà trọ này.
Yêu cầu: Sử dụng giao dịch trong thân SP, để đảm bảo tính toàn vẹn dữ liệu khi một thao tác 
xóa thực hiện không thành công */
go
create  or alter procedure sp_delete_NgayDang @TuNgay date, @DenNgay date
as 
begin try
	declare @TbNhaTro table (MaNT int)
	insert into @TbNhaTro
	select MaNT from NhaTro where NgayDangTin between @TuNgay and @DenNgay

	begin tran
		delete from DanhGia where MaNT in (select MaNT from @TbNhaTro)
		delete from NhaTro where MaNT in (select MaNT from @TbNhaTro)
		print N'Đã xóa thành công'
	commit tran
end try
begin catch
	rollback tran
	print N'Xóa không thành Công'
end catch

select * from NhaTro
-- Thực thi --
exec sp_delete_NgayDang '2023-07-22' ,'2024-07-22'
exec sp_delete_NgayDang '2024-01-15' ,'2024-01-15'
go


/* 4. Trigger
1. Tạo Trigger ràng buộc khi thêm, sửa thông tin nhà trọ phải thỏa mãn các điều kiện sau:
• Diện tích phòng >=8 (m2)
• Giá phòng >=0 */
create or alter trigger trig_DienTich on NhaTro 
		for insert, update
		as begin
			if exists (select MaNT from Inserted 
						where DienTich < 8 and GiaPhong < 0)
				begin
					print N'Không thỏa điều kiện để thêm dữ liệu'
					rollback tran
				end
		end
		go

/* 2. Tạo Trigger để khi xóa thông tin người dùng
• Nếu có các đánh giá của người dùng đó thì xóa cả đánh giá
• Nếu có thông tin liên hệ của người dùng đó trong nhà trọ thì sửa thông tin liên hệ
sang người dùng khác hoặc để trống thông tin liên hệ */
create or alter trigger trig_deleteInfor on NguoiDung
	    instead of delete 
		as begin 
			-- Xóa thông tin trong bảng đánh giá trước --
			delete from DanhGia
			where MaND in (select MaND from Inserted)
			-- Cập nhật thông tin trong --
			update NhaTro
			set MaND = 'u01'
			where MaNT in (select MaND from Inserted)
			-- Xóa thông tin này trong bảng người dùng --
			delete from NguoiDung
			where MaND in (select MaND from Inserted)
		end
	
	-- Thực thi --
	delete from NguoiDung
	where MaND = 'U07'

