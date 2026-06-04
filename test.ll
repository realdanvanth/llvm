; ModuleID = 'test.c'
source_filename = "test.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local i32 @test(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3) #0 {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  %15 = alloca i32, align 4
  %16 = alloca i32, align 4
  %17 = alloca i32, align 4
  %18 = alloca i32, align 4
  store i32 %0, ptr %5, align 4
  store i32 %1, ptr %6, align 4
  store i32 %2, ptr %7, align 4
  store i32 %3, ptr %8, align 4
  store i32 0, ptr %9, align 4
  store i32 0, ptr %10, align 4
  br label %19

19:                                               ; preds = %67, %4
  %20 = load i32, ptr %10, align 4
  %21 = load i32, ptr %8, align 4
  %22 = icmp slt i32 %20, %21
  br i1 %22, label %23, label %70

23:                                               ; preds = %19
  %24 = load i32, ptr %5, align 4
  %25 = load i32, ptr %6, align 4
  %26 = add nsw i32 %24, %25
  store i32 %26, ptr %11, align 4
  %27 = load i32, ptr %5, align 4
  %28 = load i32, ptr %6, align 4
  %29 = add nsw i32 %27, %28
  store i32 %29, ptr %12, align 4
  %30 = load i32, ptr %5, align 4
  %31 = load i32, ptr %6, align 4
  %32 = add nsw i32 %30, %31
  %33 = load i32, ptr %7, align 4
  %34 = mul nsw i32 %32, %33
  store i32 %34, ptr %13, align 4
  %35 = load i32, ptr %11, align 4
  %36 = load i32, ptr %7, align 4
  %37 = mul nsw i32 %35, %36
  store i32 %37, ptr %14, align 4
  %38 = load i32, ptr %13, align 4
  %39 = load i32, ptr %14, align 4
  %40 = add nsw i32 %38, %39
  store i32 %40, ptr %15, align 4
  %41 = load i32, ptr %13, align 4
  %42 = load i32, ptr %14, align 4
  %43 = add nsw i32 %41, %42
  store i32 %43, ptr %16, align 4
  %44 = load i32, ptr %7, align 4
  %45 = add nsw i32 %44, 10
  %46 = load i32, ptr %7, align 4
  %47 = add nsw i32 %46, 10
  %48 = mul nsw i32 %45, %47
  store i32 %48, ptr %17, align 4
  %49 = load i32, ptr %7, align 4
  %50 = add nsw i32 %49, 10
  %51 = load i32, ptr %7, align 4
  %52 = add nsw i32 %51, 10
  %53 = mul nsw i32 %50, %52
  store i32 %53, ptr %18, align 4
  %54 = load i32, ptr %11, align 4
  %55 = load i32, ptr %12, align 4
  %56 = add nsw i32 %54, %55
  %57 = load i32, ptr %15, align 4
  %58 = add nsw i32 %56, %57
  %59 = load i32, ptr %16, align 4
  %60 = add nsw i32 %58, %59
  %61 = load i32, ptr %17, align 4
  %62 = add nsw i32 %60, %61
  %63 = load i32, ptr %18, align 4
  %64 = add nsw i32 %62, %63
  %65 = load i32, ptr %9, align 4
  %66 = add nsw i32 %65, %64
  store i32 %66, ptr %9, align 4
  br label %67

67:                                               ; preds = %23
  %68 = load i32, ptr %10, align 4
  %69 = add nsw i32 %68, 1
  store i32 %69, ptr %10, align 4
  br label %19, !llvm.loop !6

70:                                               ; preds = %19
  %71 = load i32, ptr %9, align 4
  ret i32 %71
}

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local i32 @main() #0 {
  %1 = call i32 @test(i32 noundef 3, i32 noundef 4, i32 noundef 5, i32 noundef 100)
  %2 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %1)
  ret i32 0
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
!5 = !{!"clang version 22.1.5"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
