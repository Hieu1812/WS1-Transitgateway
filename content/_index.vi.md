+++
title = "Triển khai Transit Gateway để tạo kết nối giữa các VPC"
date = 2024
weight = 1
chapter = false
+++

# Triển khai Transit Gateway để tạo kết nối giữa các VPC

#### Tổng quan

Ở workshop này, chúng ta sẽ tiến hành việc triển khai **Transit Gateway** nhằm đảm bảo sự kết nối giữa các VPC. 
Thêm vào đó, chúng ta cũng sẽ triển khai **EC2 Instance** với mỗi VPC để kiểm tra tính kết nối giữa các VPC.
![launch Template](/images/graph.png)
<!-- them hinh graph -->

#### Lựa chọn giữa VPC peering và Transit Gateway
- Về bản chất, VPC peering và Transit Gateway đều giúp người dùng kết nối các VPC với nhau trong mạng lưới nội bộ. Nhưng tùy vào quy mô của hệ thống mà chúng ta chọn. Với hệ thống chỉ có từ 3 VPC trở xuống ta có thể sử dụng VPC peering với 3 peering connection. Khi hệ thống phức tạp, nhiều VPC thì ta sẽ phải khởi tạo nhiều peering connection tạo sự bất tiện, khó kiểm soát và khả năng mở rộng thấp. Cũng vì đó mà xuất hiện Transit Gateway. 
#### Transit Gateway
-  Được sinh ra để giải quyết những nhược điểm của Peering Conenction, Transite Gateway được dùng để kết nối các VPC và mạng on-premises thông qua một hub trung tâm. Điều này đơn giản hoá mạng và kết thúc các mối quan hệ định tuyến phức tạp.
#### VPC
- Amazon Virtual Private Cloud (Amazon VPC) là dịch vụ cho phép bạn khởi chạy các tài nguyên AWS trong mạng ảo cô lập theo logic mà bạn xác định. Bạn có toàn quyền kiểm soát môi trường mạng ảo của mình, bao gồm lựa chọn dải địa chỉ IP, tạo các mạng con, cấu hình các bảng định tuyến và cổng kết nối mạng.
#### EC2 Instance
- Là một cơ sở hạ tầng điện toán đám mây được cung cấp bởi Amazon Web Services (AWS) giúp cung cấp tài nguyên máy tính ảo hoá theo yêu cầu.Tương tự với máy chủ , EC2 được tạo nhanh chóng và đảm bảo tính sẵn sàng cao nhất.

{{% notice info %}}File terraform của bài workshop [Link](https://github.com/Hieu1812/WS1-Transitgateway/blob/main/main.tf){{% /notice %}}
#### Nội dung:
1. [Khởi tạo VPC](1-VPC)
2. [Khởi tạo EC2](2-EC2)
3. [Khởi tạo Transit Gateway](3-Transit%20Gateway)
4. [Gắn Transit Gateway Attachment với từng VPC](4-Transit%20Gateway%20Attachment) 
5. [Tạo Transit Gateway route table và kiểm tra kết nối ](5-Transit%20Gateway%20route%20table)
6. [Dọn dẹp tài nguyên](6-Clean%20up)