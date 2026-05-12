; ModuleID = 'test.c'
source_filename = "test.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i32 0, ptr %1, align 4
  store volatile i32 0, ptr %2, align 4
  store i32 0, ptr %3, align 4
  br label %6

6:                                                ; preds = %56, %0
  %7 = load i32, ptr %3, align 4
  %8 = icmp slt i32 %7, 500000000
  br i1 %8, label %9, label %59

9:                                                ; preds = %6
  %10 = load i32, ptr %3, align 4
  %11 = srem i32 %10, 100
  store i32 %11, ptr %4, align 4
  %12 = load i32, ptr %4, align 4
  %13 = mul nsw i32 5, %12
  %14 = load i32, ptr %4, align 4
  %15 = mul nsw i32 %13, %14
  %16 = load i32, ptr %4, align 4
  %17 = mul nsw i32 %15, %16
  %18 = load i32, ptr %4, align 4
  %19 = mul nsw i32 %17, %18
  %20 = load i32, ptr %4, align 4
  %21 = mul nsw i32 5, %20
  %22 = load i32, ptr %4, align 4
  %23 = mul nsw i32 %21, %22
  %24 = load i32, ptr %4, align 4
  %25 = mul nsw i32 %23, %24
  %26 = load i32, ptr %4, align 4
  %27 = mul nsw i32 %25, %26
  %28 = add nsw i32 %19, %27
  %29 = load i32, ptr %4, align 4
  %30 = mul nsw i32 3, %29
  %31 = load i32, ptr %4, align 4
  %32 = mul nsw i32 %30, %31
  %33 = load i32, ptr %4, align 4
  %34 = mul nsw i32 %32, %33
  %35 = add nsw i32 %28, %34
  %36 = load i32, ptr %4, align 4
  %37 = mul nsw i32 3, %36
  %38 = load i32, ptr %4, align 4
  %39 = mul nsw i32 %37, %38
  %40 = load i32, ptr %4, align 4
  %41 = mul nsw i32 %39, %40
  %42 = add nsw i32 %35, %41
  %43 = load i32, ptr %4, align 4
  %44 = mul nsw i32 2, %43
  %45 = load i32, ptr %4, align 4
  %46 = mul nsw i32 %44, %45
  %47 = add nsw i32 %42, %46
  %48 = load i32, ptr %4, align 4
  %49 = mul nsw i32 2, %48
  %50 = load i32, ptr %4, align 4
  %51 = mul nsw i32 %49, %50
  %52 = add nsw i32 %47, %51
  store i32 %52, ptr %5, align 4
  %53 = load i32, ptr %5, align 4
  %54 = load volatile i32, ptr %2, align 4
  %55 = add nsw i32 %54, %53
  store volatile i32 %55, ptr %2, align 4
  br label %56

56:                                               ; preds = %9
  %57 = load i32, ptr %3, align 4
  %58 = add nsw i32 %57, 1
  store i32 %58, ptr %3, align 4
  br label %6, !llvm.loop !6

59:                                               ; preds = %6
  %60 = load volatile i32, ptr %2, align 4
  %61 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %60)
  %62 = load i32, ptr %1, align 4
  ret i32 %62
}

declare i32 @printf(ptr noundef, ...) #1

attributes #0 = { noinline nounwind sspstrong uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"clang version 22.1.3"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
