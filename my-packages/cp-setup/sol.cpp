#include <bits/stdc++.h>
using namespace std;
#define fwd(i, a, n) for (int i = (a); i < (n); i++)
#define rep(i, n) fwd(i, 0, n)
#define all(X) X.begin(), X.end()
#define sz(X) int(size(X))
#define pb push_back
#define eb emplace_back
#define st first
#define nd second
using pii = pair<int, int>; using vi = vector<int>;
using ll = long long; using ld = long double;
#ifdef LOC
auto SS = signal(6, [](int) { *(int *)0 = 0; });
#define DTP(x, y) auto operator << (auto &o, auto a) -> decltype(y, o) { o << "("; x; return o << ")"; }
DTP(o << a.st << ", " << a.nd, a.nd);
DTP(for (auto i : a) o << i << ", ", all(a));
void dump(auto... x) { (( cerr << x << ", " ), ...) << '\n'; }
#define deb(x...) cerr << setw(4) << __LINE__ << ":[" #x "]: ", dump(x)
#else
#define deb(...) 0
#endif
int32_t main() {
    cin.tie(0)->sync_with_stdio(0);
    cout << fixed << setprecision(10);
    #ifdef LOC
    cout.flush(); cerr << "- - - - - - - - -\n";
    (void)!system("grep VmPeak /proc/$PPID/status | sed s/....kB/\' MB\'/1 >&2"); // 4x.kB ....kB
    #endif
}
