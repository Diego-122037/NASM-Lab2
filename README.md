# NASM-Lab2

Drugie laboratorium z NASM przygotowane do pracy w środowisku GitHub Codespaces.

## Cel laboratorium

Celem zajęć jest zapoznanie studenta z:

- instrukcją `cmp`,
- bezwarunkowymi i warunkowymi skokami,
- organizacją prostego przepływu sterowania w programie,
- wykorzystaniem pętli w asemblerze,
- analizą działania programu krok po kroku w debuggerze GDB.

## Struktura projektu

- `src/main.asm` — plik zawierający główną implementację programu w asemblerze NASM,
- `Makefile` — plik opisujący sposób kompilacji i budowania programu,
- `.vscode/launch.json` — konfiguracja sesji uruchomieniowych i debugowania w edytorze VS Code,
- `.vscode/tasks.json` — konfiguracja zadań automatyzujących proces budowania w VS Code,
- `.devcontainer/` — katalog zawierający konfigurację środowiska uruchamianego w GitHub Codespaces.

## Budowanie programu

Program można zbudować ręcznie poleceniem:

```bash
make
```

W standardowej konfiguracji projektu ręczne wywołanie `make` nie jest jednak konieczne przed uruchomieniem debugowania w VS Code.
Jeżeli w pliku `launch.json` ustawiono parametr `preLaunchTask`, edytor automatycznie uruchomi zadanie budowania przed rozpoczęciem sesji debugowania.

## Uruchamianie programu

Program jest uruchamiany z poziomu debuggera w VS Code.
W standardowej konfiguracji przed rozpoczęciem debugowania automatycznie wykonywane jest zadanie budowania projektu.

Najprostszy sposób uruchomienia:

1. Otwórz panel **Run and Debug**.
2. Wybierz konfigurację debugowania.
3. Naciśnij `F5`.

Alternatywnie debugowanie można uruchomić również z poziomu palety poleceń albo skrótu `Ctrl+Shift+D`.

## Debugowanie

Podczas debugowania można obserwować:

- bieżącą instrukcję,
- wartości rejestrów procesora,
- zmiany przepływu wykonania po instrukcjach porównania,
- przebieg pętli oraz wyniki kolejnych porównań.

W szczególności warto śledzić rejestry używane jako licznik pętli oraz akumulator, a także sprawdzać, które skoki warunkowe zostały wykonane po instrukcji `cmp`.

Przydatne polecenia GDB:

```gdb
break _start
run
si
info registers
display /i $pc
```

## Program początkowy

Program początkowy przedstawia podstawowe użycie instrukcji porównania oraz skoków warunkowych.
W jego działaniu wykorzystywane są rejestry pełniące rolę licznika pętli oraz akumulatora, którego wartość jest modyfikowana w kolejnych krokach wykonania programu.

Celem programu jest umożliwienie pierwszego kontaktu z:

- instrukcją `cmp`,
- warunkowym sterowaniem przebiegiem programu,
- realizacją prostej pętli,
- obserwacją zmian wartości rejestrów podczas kolejnych iteracji.

```nasm
global _start

section .text
_start:
    mov rax, 0
    mov rcx, 0

loop_start:
    cmp rcx, 5
    jge end_loop

    add rax, 3
    add rcx, 1
    jmp loop_start

end_loop:
    mov rdi, 0
    mov rax, 60
    syscall
```

## Zadania

1. Opisać, jakie zadanie wykonuje program początkowy.
2. Korzystając z instrukcji porównania oraz skoków warunkowych, napisać program, który w pętli zwiększa wartość akumulatora o `3` w każdym kroku pętli.
3. Napisać program wykonujący algorytm sortowania bąbelkowego dla tablicy zawierającej 5 elementów: `3, 4, 1, 2, 5`.

## Uwagi

Pliki wynikowe kompilacji nie powinny być commitowane do repozytorium.
Są one ignorowane przez `.gitignore`.

*Last updated: 2026-10-09*
