/* Batch 200d step 2 - call the runtime's own entry point from plain C.
 *
 * Step 1 proved comctl32 v5.82 creates image lists fine in this environment, so the zero
 * handle is NOT a comctl32/v6 problem.  That splits the remaining ground in two:
 *
 *   pb_imagelist_new(...) returns non-zero here  -> the runtime function is fine and the
 *                                                   defect is in the PB call/return path
 *   pb_imagelist_new(...) returns 0 here         -> the defect is inside the runtime function
 *
 * Links the very object the examples link (pb_runtime_x64.obj in the repository root).
 */
#include <stdio.h>

extern long long pb_imagelist_new(int width, int height, int depth, int initial, int is_icon);
extern int pb_imagelist_count(long long h);
extern int pb_imagelist_kill(long long h);

int main(void)
{
    long long a = pb_imagelist_new(16, 16, 32, 4, 0);      /* bitmap list, ILC_COLOR32 */
    long long b = pb_imagelist_new(16, 16, 32, 2, 1);      /* icon list  */
    printf("runtime pb_imagelist_new bitmap = 0x%llX  (%lld)\n", a, a);
    printf("runtime pb_imagelist_new icon   = 0x%llX  (%lld)\n", b, b);
    printf("runtime low 32 bits bitmap      = %u\n", (unsigned)a);
    printf("count(bitmap) = %d   count(icon) = %d\n", pb_imagelist_count(a), pb_imagelist_count(b));
    printf("kill(bitmap)  = %d   kill(icon)  = %d\n", pb_imagelist_kill(a), pb_imagelist_kill(b));
    return 0;
}
