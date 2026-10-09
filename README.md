# NASM-Lab2

Drugie laboratorium z NASM przygotowane do pracy w środowisku GitHub Codespaces.

## Cel laboratorium

Celem zajęć jest zapoznanie studenta z:

- instrukcją `cmp`,
- bezwarunkowymi i warunkowymi skokami,
- instrukcją `loop` i wykorzystaniem rejestru `rcx` jako licznika pętli,
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

## Instrukcja cmp i skoki

Instrukcja `cmp` porównuje dwa operandy poprzez wykonanie odejmowania drugiego operandu od pierwszego, nie zapisuje jednak wyniku działania w rejestrze ani w pamięci.
Jej zadaniem jest wyłącznie ustawienie flag procesora, które mogą zostać następnie wykorzystane przez instrukcje skoku warunkowego.

Instrukcja `cmp` modyfikuje między innymi następujące flagi:

- `ZF` (*Zero Flag*) — przyjmuje wartość `1`, jeżeli oba operandy są równe,
- `SF` (*Sign Flag*) — przyjmuje wartość `1`, jeżeli wynik porównania ma znak ujemny,
- `CF` (*Carry Flag*) — przyjmuje wartość `1`, jeżeli podczas odejmowania wystąpi pożyczka,
- `OF` (*Overflow Flag*) — przyjmuje wartość `1`, jeżeli wystąpi przepełnienie rejestru, np. przy interpretacji wyniku jako liczby ze znakiem,
- `PF` (*Parity Flag*) — zależy od parzystości najmłodszego bajtu wyniku.

W programie wykorzystywane są następujące instrukcje skoku:

- `je` — wykonuje skok, jeżeli `ZF = 1`,
- `jg` — wykonuje skok, jeżeli pierwszy operand jest większy od drugiego dla porównania ze znakiem,
- `jl` — wykonuje skok, jeżeli pierwszy operand jest mniejszy od drugiego dla porównania ze znakiem,
- `jmp` — wykonuje skok bezwarunkowy,
- `loop` — zmniejsza wartość rejestru `rcx` o `1` i wykonuje skok, jeżeli po zmniejszeniu rejestr `rcx` jest różny od zera.

Instrukcja `loop` umożliwia realizację pętli z wykorzystaniem rejestru `rcx` jako licznika.
Po jej wykonaniu wartość rejestru `rcx` jest zmniejszana o `1`. Jeżeli po zmniejszeniu `rcx` ma wartość różną od zera, wykonywany jest skok do wskazanej etykiety.

Przykład:

```nasm
mov rax, 0
mov rcx, 5

loop_start:
    add rax, 3
    loop loop_start
```

W przedstawionym przykładzie ciało pętli zostanie wykonane pięć razy, a rejestr `rax` zostanie zwiększony o `3` w każdej iteracji.

## Program początkowy

```nasm
global _start

section .text
_start:
    mov rax, 7          ; operand1
    mov rbx, 3          ; operand2

    cmp rax, rbx
    je equal
    jg greater
    jl less

greater:
    mov rdi, 1
    jmp exit_program

equal:
    mov rdi, 0
    jmp exit_program

less:
    mov rdi, -1

exit_program:
    mov rax, 60
    syscall
```

## Debugowanie

Podczas debugowania można obserwować:

- bieżącą instrukcję,
- wartości rejestrów procesora,
- zmiany flag po wykonaniu instrukcji `cmp`,
- przebieg wykonania programu po skokach warunkowych.

W szczególności warto śledzić rejestry `rax`, `rbx` oraz `rdi`, a także sprawdzać stan flag po wykonaniu instrukcji porównania.

Przydatne polecenia GDB:

```gdb
break _start
run
si
info registers
display /i $pc
```

## Zadania

1. Opisać, jakie zadanie wykonuje program początkowy.
2. Korzystając z instrukcji porównania oraz skoków warunkowych, napisać program, który w pętli zwiększa wartość akumulatora o `3` w każdym kroku pętli.
3. Zmodyfikować program z zadania 2 w taki sposób, aby w każdym kroku pętli wartość akumulatora była zwiększana o aktualną wartość licznika.
4. Napisać program wykonujący algorytm sortowania bąbelkowego dla tablicy zawierającej 5 elementów: `3, 4, 1, 2, 5`.

## Uwagi

Pliki wynikowe kompilacji nie powinny być commitowane do repozytorium.
Są one ignorowane przez `.gitignore`.

*Last updated: 2026-10-09*
