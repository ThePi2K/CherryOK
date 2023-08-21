======================================================================
                     FastCopy  ver5.3.0                2023/08/12
                                            H.Shirouzu（白水啓章）
                                            FastCopy Lab, LLC.
======================================================================

特徴：
  Windows系最速のファイルコピー＆削除ツールです。

  NT系OS の場合、UNICODE でしか表現できないファイル名や MAX_PATH
  (260文字) を越えた位置のファイルもコピー（＆削除）できます。

  自動的に、コピー元とコピー先が、同一の物理HDD or 別HDD かを判定
  した後、以下の動作を行います。

    別HDD 間：
      マルチスレッドで、読み込みと書き込みを並列に行う

    同一HDD 間：
      コピー元から（バッファが一杯になるまで）連続読み込み後、
      コピー先に連続して書き込む

  Read/Write も、OS のキャッシュを全く使わないため、他のプロセス
  （アプリケーション）が重くなりにくくなっています。

  可能な限り大きな単位で Read/Write するため、デバイスの限界に
  近いパフォーマンスが出ます。

  Include/Exclude フィルタ（UNIXワイルドカード形式）が指定可能です。

  MFC 等のフレームワークを使わず、Win32API だけで作っていますので、
  軽量＆コンパクト＆軽快に動作します。


FastCopy利用許諾契約 (EULA):

  1. （利用許諾）このソフトウェアは、職場等の非家庭環境で使う場合、
      Pro版ライセンスが必要となります。家庭内の個人（非営利）として
      使う場合のみ、無償で使うことができます。

  2. （免責）FastCopy Lab, LLC. により「あるがままの状態」で提供され、
      いかなる瑕疵に対しても対応責任及び賠償責任を負いません。

  3. （リバースエンジニアリングの禁止）いかなる方法でも、
      リバースエンジニアリングを禁止します。

  4. （譲渡禁止）Pro版ライセンスを第三者に貸与、譲渡、サブライセンス
      することを禁止します。

  Copyright 2004-2023 SHIROUZU Hiroaki All rights reserved.
  Copyright 2018-2023 FastCopy Lab, LLC. All rights reserved.

  xxHash library
    Copyright (C) 2012-2021 Mr.Yann Collet, All rights reserved.
    more details: doc/xxhash-LICENSE.txt

  OpenSSL library Copyright (C) 1998-2022 The OpenSSL Project,
    All rights reserved. more details: doc/apache-license-2.0.txt

使用法等：
  ヘルプ(fastcopy.htm) を参照してください。

