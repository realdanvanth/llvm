; ModuleID = 'test.c'
source_filename = "test.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local void @test() #0 {
  %1 = alloca ptr, align 8
  %2 = alloca ptr, align 8
  %3 = alloca ptr, align 8
  %4 = alloca i32, align 4
  %5 = alloca ptr, align 8
  %6 = alloca ptr, align 8
  %7 = alloca i32, align 4
  %8 = alloca ptr, align 8
  %9 = call noalias ptr @malloc(i64 noundef 4) #3
  store ptr %9, ptr %1, align 8
  %10 = load ptr, ptr %1, align 8
  call void @free(ptr noundef %10) #4
  %11 = call noalias ptr @malloc(i64 noundef 4) #3
  store ptr %11, ptr %2, align 8
  %12 = load ptr, ptr %2, align 8
  call void @free(ptr noundef %12) #4
  %13 = load ptr, ptr %2, align 8
  call void @free(ptr noundef %13) #4
  %14 = call noalias ptr @malloc(i64 noundef 4) #3
  store ptr %14, ptr %3, align 8
  %15 = load ptr, ptr %3, align 8
  call void @free(ptr noundef %15) #4
  %16 = load ptr, ptr %3, align 8
  %17 = load i32, ptr %16, align 4
  store i32 %17, ptr %4, align 4
  %18 = call noalias ptr @malloc(i64 noundef 4) #3
  store ptr %18, ptr %5, align 8
  %19 = load ptr, ptr %5, align 8
  call void @free(ptr noundef %19) #4
  %20 = load ptr, ptr %5, align 8
  store i32 5, ptr %20, align 4
  %21 = call noalias ptr @malloc(i64 noundef 16) #3
  store ptr %21, ptr %6, align 8
  %22 = load ptr, ptr %6, align 8
  call void @free(ptr noundef %22) #4
  %23 = load ptr, ptr %6, align 8
  %24 = getelementptr inbounds i32, ptr %23, i64 2
  %25 = load i32, ptr %24, align 4
  store i32 %25, ptr %7, align 4
  %26 = call noalias ptr @malloc(i64 noundef 4) #3
  store ptr %26, ptr %8, align 8
  ret void
}

; Function Attrs: nounwind allocsize(0)
declare noalias ptr @malloc(i64 noundef) #1

; Function Attrs: nounwind
declare void @free(ptr noundef) #2

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local i32 @main() #0 {
  call void @test()
  ret i32 0
}

attributes #0 = { noinline nounwind sspstrong uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind allocsize(0) }
attributes #4 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"clang version 22.1.3"}
