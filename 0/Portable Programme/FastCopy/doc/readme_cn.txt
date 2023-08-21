======================================================================
                     FastCopy  ver5.3.0                2023/08/12
                                            H.Shirouzu（白水啓章）
                                            FastCopy Lab, LLC.
======================================================================

功能：
  FastCopy是Windows上最快 的文件复制＆备份软件。 

  可复制（＆删除）UNICODE和超过MAX_PATH（260个字）的文件路径名。

  它会判断来源与目标是否属于同一HDD(or SSD)，自动选择不同的方法。
   - 不同HDD 有多线程能力，读取与写入由单独的线程并行处理。
   - 相同HDD 从目标连续读取直到充满缓冲区。缓冲器填满时，才开始写入至目标。

  读/写也完全不使用操作系统的缓存，因此其他进程（应用程序）不会被减慢。
  它可以实现接近设备极限的读写性能。
  可指定包含/排除过滤器（UNIX通配符样式）。
  因没有使用MFC，仅使用Win32API设计，不会贪占资源，运行快速。

FastCopy许可协议 (EULA)：

  1.（使用许可）本软件在非家庭环境（如工作场所）中使用时需要Pro版许可。
     只有在家庭环境中作为个人（非商业）使用时才能免费使用。
  2.（免责声明）) 由FastCopy Lab, LLC.在 "原样 "基础上提供，
     对任何缺陷不承担任何责任或义务。
  3.（禁止逆向工程）禁止以任何方式进行逆向工程。
  4.（禁止转让）禁止将Pro版许可证出借、转让或分许可给第三方。

  Copyright 2004-2023 SHIROUZU Hiroaki All rights reserved.
  Copyright 2018-2023 FastCopy Lab, LLC. All rights reserved.

  xxHash library
    Copyright (C) 2012-2021 Mr.Yann Collet, All rights reserved.
    more details: doc/xxhash-LICENSE.txt

  OpenSSL library Copyright (C) 1998-2022 The OpenSSL Project,
    All rights reserved. more details: doc/apache-license-2.0.txt

用法等：
  见帮助（fastcopy_cn.chm）。

