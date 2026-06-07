; ModuleID = 'test.c'
source_filename = "test.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1, !dbg !0

; Function Attrs: noinline nounwind sspstrong uwtable
define dso_local i32 @test(i32 noundef %a, i32 noundef %b, i32 noundef %c, i32 noundef %n) #0 !dbg !17 {
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca i32, align 4
  %c.addr = alloca i32, align 4
  %n.addr = alloca i32, align 4
  %sum = alloca i32, align 4
  %i = alloca i32, align 4
  %x1 = alloca i32, align 4
  %x2 = alloca i32, align 4
  %x3 = alloca i32, align 4
  %x4 = alloca i32, align 4
  %x5 = alloca i32, align 4
  %x6 = alloca i32, align 4
  %x7 = alloca i32, align 4
  %x8 = alloca i32, align 4
  store i32 %a, ptr %a.addr, align 4
    #dbg_declare(ptr %a.addr, !22, !DIExpression(), !23)
  store i32 %b, ptr %b.addr, align 4
    #dbg_declare(ptr %b.addr, !24, !DIExpression(), !25)
  store i32 %c, ptr %c.addr, align 4
    #dbg_declare(ptr %c.addr, !26, !DIExpression(), !27)
  store i32 %n, ptr %n.addr, align 4
    #dbg_declare(ptr %n.addr, !28, !DIExpression(), !29)
    #dbg_declare(ptr %sum, !30, !DIExpression(), !31)
  store i32 0, ptr %sum, align 4, !dbg !31
    #dbg_declare(ptr %i, !32, !DIExpression(), !34)
  store i32 0, ptr %i, align 4, !dbg !34
  br label %for.cond, !dbg !35

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, ptr %i, align 4, !dbg !36
  %1 = load i32, ptr %n.addr, align 4, !dbg !38
  %cmp = icmp slt i32 %0, %1, !dbg !39
  br i1 %cmp, label %for.body, label %for.end, !dbg !40

for.body:                                         ; preds = %for.cond
    #dbg_declare(ptr %x1, !41, !DIExpression(), !43)
  %2 = load i32, ptr %a.addr, align 4, !dbg !44
  %3 = load i32, ptr %b.addr, align 4, !dbg !45
  %add = add nsw i32 %2, %3, !dbg !46
  store i32 %add, ptr %x1, align 4, !dbg !43
    #dbg_declare(ptr %x2, !47, !DIExpression(), !48)
  %4 = load i32, ptr %a.addr, align 4, !dbg !49
  %5 = load i32, ptr %b.addr, align 4, !dbg !50
  %add1 = add nsw i32 %4, %5, !dbg !51
  store i32 %add1, ptr %x2, align 4, !dbg !48
  store i32 2, ptr %x1, align 4, !dbg !52
    #dbg_declare(ptr %x3, !53, !DIExpression(), !54)
  %6 = load i32, ptr %a.addr, align 4, !dbg !55
  %7 = load i32, ptr %b.addr, align 4, !dbg !56
  %add2 = add nsw i32 %6, %7, !dbg !57
  %8 = load i32, ptr %c.addr, align 4, !dbg !58
  %mul = mul nsw i32 %add2, %8, !dbg !59
  store i32 %mul, ptr %x3, align 4, !dbg !54
    #dbg_declare(ptr %x4, !60, !DIExpression(), !61)
  %9 = load i32, ptr %x1, align 4, !dbg !62
  %10 = load i32, ptr %c.addr, align 4, !dbg !63
  %mul3 = mul nsw i32 %9, %10, !dbg !64
  store i32 %mul3, ptr %x4, align 4, !dbg !61
    #dbg_declare(ptr %x5, !65, !DIExpression(), !66)
  %11 = load i32, ptr %x3, align 4, !dbg !67
  %12 = load i32, ptr %x4, align 4, !dbg !68
  %add4 = add nsw i32 %11, %12, !dbg !69
  store i32 %add4, ptr %x5, align 4, !dbg !66
    #dbg_declare(ptr %x6, !70, !DIExpression(), !71)
  %13 = load i32, ptr %x3, align 4, !dbg !72
  %14 = load i32, ptr %x4, align 4, !dbg !73
  %add5 = add nsw i32 %13, %14, !dbg !74
  store i32 %add5, ptr %x6, align 4, !dbg !71
    #dbg_declare(ptr %x7, !75, !DIExpression(), !76)
  %15 = load i32, ptr %c.addr, align 4, !dbg !77
  %add6 = add nsw i32 %15, 10, !dbg !78
  %16 = load i32, ptr %c.addr, align 4, !dbg !79
  %add7 = add nsw i32 %16, 10, !dbg !80
  %mul8 = mul nsw i32 %add6, %add7, !dbg !81
  store i32 %mul8, ptr %x7, align 4, !dbg !76
    #dbg_declare(ptr %x8, !82, !DIExpression(), !83)
  %17 = load i32, ptr %c.addr, align 4, !dbg !84
  %add9 = add nsw i32 %17, 10, !dbg !85
  %18 = load i32, ptr %c.addr, align 4, !dbg !86
  %add10 = add nsw i32 %18, 10, !dbg !87
  %mul11 = mul nsw i32 %add9, %add10, !dbg !88
  store i32 %mul11, ptr %x8, align 4, !dbg !83
  %19 = load i32, ptr %x1, align 4, !dbg !89
  %20 = load i32, ptr %x2, align 4, !dbg !90
  %add12 = add nsw i32 %19, %20, !dbg !91
  %21 = load i32, ptr %x5, align 4, !dbg !92
  %add13 = add nsw i32 %add12, %21, !dbg !93
  %22 = load i32, ptr %x6, align 4, !dbg !94
  %add14 = add nsw i32 %add13, %22, !dbg !95
  %23 = load i32, ptr %x7, align 4, !dbg !96
  %add15 = add nsw i32 %add14, %23, !dbg !97
  %24 = load i32, ptr %x8, align 4, !dbg !98
  %add16 = add nsw i32 %add15, %24, !dbg !99
  %25 = load i32, ptr %sum, align 4, !dbg !100
  %add17 = add nsw i32 %25, %add16, !dbg !100
  store i32 %add17, ptr %sum, align 4, !dbg !100
  br label %for.inc, !dbg !101

for.inc:                                          ; preds = %for.body
  %26 = load i32, ptr %i, align 4, !dbg !102
  %inc = add nsw i32 %26, 1, !dbg !102
  store i32 %inc, ptr %i, align 4, !dbg !102
  br label %for.cond, !dbg !103, !llvm.loop !104

for.end:                                          ; preds = %for.cond
  %27 = load i32, ptr %sum, align 4, !dbg !107
  ret i32 %27, !dbg !108
}

; Function Attrs: noinline nounwind sspstrong uwtable
define dso_local i32 @main() #0 !dbg !109 {
entry:
  %call = call i32 @test(i32 noundef 3, i32 noundef 4, i32 noundef 5, i32 noundef 100), !dbg !112
  %call1 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %call), !dbg !113
  ret i32 0, !dbg !114
}

declare i32 @printf(ptr noundef, ...) #1

attributes #0 = { noinline nounwind sspstrong uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.dbg.cu = !{!7}
!llvm.module.flags = !{!9, !10, !11, !12, !13, !14, !15}
!llvm.ident = !{!16}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(scope: null, file: !2, line: 25, type: !3, isLocal: true, isDefinition: true)
!2 = !DIFile(filename: "test.c", directory: "/home/real/code/intern/llvm", checksumkind: CSK_MD5, checksum: "fbe37fd2306f0c2747331637b9fa6d6e")
!3 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 32, elements: !5)
!4 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!5 = !{!6}
!6 = !DISubrange(count: 4)
!7 = distinct !DICompileUnit(language: DW_LANG_C11, file: !2, producer: "clang version 22.1.5", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !8, splitDebugInlining: false, nameTableKind: None)
!8 = !{!0}
!9 = !{i32 7, !"Dwarf Version", i32 5}
!10 = !{i32 2, !"Debug Info Version", i32 3}
!11 = !{i32 1, !"wchar_size", i32 4}
!12 = !{i32 8, !"PIC Level", i32 2}
!13 = !{i32 7, !"PIE Level", i32 2}
!14 = !{i32 7, !"uwtable", i32 2}
!15 = !{i32 7, !"frame-pointer", i32 2}
!16 = !{!"clang version 22.1.5"}
!17 = distinct !DISubprogram(name: "test", scope: !2, file: !2, line: 3, type: !18, scopeLine: 3, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !21)
!18 = !DISubroutineType(types: !19)
!19 = !{!20, !20, !20, !20, !20}
!20 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!21 = !{}
!22 = !DILocalVariable(name: "a", arg: 1, scope: !17, file: !2, line: 3, type: !20)
!23 = !DILocation(line: 3, column: 14, scope: !17)
!24 = !DILocalVariable(name: "b", arg: 2, scope: !17, file: !2, line: 3, type: !20)
!25 = !DILocation(line: 3, column: 21, scope: !17)
!26 = !DILocalVariable(name: "c", arg: 3, scope: !17, file: !2, line: 3, type: !20)
!27 = !DILocation(line: 3, column: 28, scope: !17)
!28 = !DILocalVariable(name: "n", arg: 4, scope: !17, file: !2, line: 3, type: !20)
!29 = !DILocation(line: 3, column: 35, scope: !17)
!30 = !DILocalVariable(name: "sum", scope: !17, file: !2, line: 4, type: !20)
!31 = !DILocation(line: 4, column: 7, scope: !17)
!32 = !DILocalVariable(name: "i", scope: !33, file: !2, line: 6, type: !20)
!33 = distinct !DILexicalBlock(scope: !17, file: !2, line: 6, column: 3)
!34 = !DILocation(line: 6, column: 12, scope: !33)
!35 = !DILocation(line: 6, column: 8, scope: !33)
!36 = !DILocation(line: 6, column: 19, scope: !37)
!37 = distinct !DILexicalBlock(scope: !33, file: !2, line: 6, column: 3)
!38 = !DILocation(line: 6, column: 23, scope: !37)
!39 = !DILocation(line: 6, column: 21, scope: !37)
!40 = !DILocation(line: 6, column: 3, scope: !33)
!41 = !DILocalVariable(name: "x1", scope: !42, file: !2, line: 7, type: !20)
!42 = distinct !DILexicalBlock(scope: !37, file: !2, line: 6, column: 31)
!43 = !DILocation(line: 7, column: 9, scope: !42)
!44 = !DILocation(line: 7, column: 14, scope: !42)
!45 = !DILocation(line: 7, column: 18, scope: !42)
!46 = !DILocation(line: 7, column: 16, scope: !42)
!47 = !DILocalVariable(name: "x2", scope: !42, file: !2, line: 8, type: !20)
!48 = !DILocation(line: 8, column: 9, scope: !42)
!49 = !DILocation(line: 8, column: 14, scope: !42)
!50 = !DILocation(line: 8, column: 18, scope: !42)
!51 = !DILocation(line: 8, column: 16, scope: !42)
!52 = !DILocation(line: 9, column: 8, scope: !42)
!53 = !DILocalVariable(name: "x3", scope: !42, file: !2, line: 10, type: !20)
!54 = !DILocation(line: 10, column: 9, scope: !42)
!55 = !DILocation(line: 10, column: 15, scope: !42)
!56 = !DILocation(line: 10, column: 19, scope: !42)
!57 = !DILocation(line: 10, column: 17, scope: !42)
!58 = !DILocation(line: 10, column: 24, scope: !42)
!59 = !DILocation(line: 10, column: 22, scope: !42)
!60 = !DILocalVariable(name: "x4", scope: !42, file: !2, line: 11, type: !20)
!61 = !DILocation(line: 11, column: 9, scope: !42)
!62 = !DILocation(line: 11, column: 14, scope: !42)
!63 = !DILocation(line: 11, column: 19, scope: !42)
!64 = !DILocation(line: 11, column: 17, scope: !42)
!65 = !DILocalVariable(name: "x5", scope: !42, file: !2, line: 13, type: !20)
!66 = !DILocation(line: 13, column: 9, scope: !42)
!67 = !DILocation(line: 13, column: 14, scope: !42)
!68 = !DILocation(line: 13, column: 19, scope: !42)
!69 = !DILocation(line: 13, column: 17, scope: !42)
!70 = !DILocalVariable(name: "x6", scope: !42, file: !2, line: 14, type: !20)
!71 = !DILocation(line: 14, column: 9, scope: !42)
!72 = !DILocation(line: 14, column: 14, scope: !42)
!73 = !DILocation(line: 14, column: 19, scope: !42)
!74 = !DILocation(line: 14, column: 17, scope: !42)
!75 = !DILocalVariable(name: "x7", scope: !42, file: !2, line: 16, type: !20)
!76 = !DILocation(line: 16, column: 9, scope: !42)
!77 = !DILocation(line: 16, column: 15, scope: !42)
!78 = !DILocation(line: 16, column: 17, scope: !42)
!79 = !DILocation(line: 16, column: 26, scope: !42)
!80 = !DILocation(line: 16, column: 28, scope: !42)
!81 = !DILocation(line: 16, column: 23, scope: !42)
!82 = !DILocalVariable(name: "x8", scope: !42, file: !2, line: 17, type: !20)
!83 = !DILocation(line: 17, column: 9, scope: !42)
!84 = !DILocation(line: 17, column: 15, scope: !42)
!85 = !DILocation(line: 17, column: 17, scope: !42)
!86 = !DILocation(line: 17, column: 26, scope: !42)
!87 = !DILocation(line: 17, column: 28, scope: !42)
!88 = !DILocation(line: 17, column: 23, scope: !42)
!89 = !DILocation(line: 19, column: 12, scope: !42)
!90 = !DILocation(line: 19, column: 17, scope: !42)
!91 = !DILocation(line: 19, column: 15, scope: !42)
!92 = !DILocation(line: 19, column: 22, scope: !42)
!93 = !DILocation(line: 19, column: 20, scope: !42)
!94 = !DILocation(line: 19, column: 27, scope: !42)
!95 = !DILocation(line: 19, column: 25, scope: !42)
!96 = !DILocation(line: 19, column: 32, scope: !42)
!97 = !DILocation(line: 19, column: 30, scope: !42)
!98 = !DILocation(line: 19, column: 37, scope: !42)
!99 = !DILocation(line: 19, column: 35, scope: !42)
!100 = !DILocation(line: 19, column: 9, scope: !42)
!101 = !DILocation(line: 20, column: 3, scope: !42)
!102 = !DILocation(line: 6, column: 27, scope: !37)
!103 = !DILocation(line: 6, column: 3, scope: !37)
!104 = distinct !{!104, !40, !105, !106}
!105 = !DILocation(line: 20, column: 3, scope: !33)
!106 = !{!"llvm.loop.mustprogress"}
!107 = !DILocation(line: 22, column: 10, scope: !17)
!108 = !DILocation(line: 22, column: 3, scope: !17)
!109 = distinct !DISubprogram(name: "main", scope: !2, file: !2, line: 25, type: !110, scopeLine: 25, spFlags: DISPFlagDefinition, unit: !7)
!110 = !DISubroutineType(types: !111)
!111 = !{!20}
!112 = !DILocation(line: 25, column: 29, scope: !109)
!113 = !DILocation(line: 25, column: 14, scope: !109)
!114 = !DILocation(line: 25, column: 50, scope: !109)
