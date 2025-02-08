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
#define DTP(x, y) auto operator<<(auto &o, auto a) -> decltype(y, o) { o << "("; x; return o << ")"; }
auto operator<<(auto &o, auto a) -> decltype(all(a), o);
DTP(o << a.st << ", " << a.nd, a.nd);
DTP(for (auto i : a) o << i << ", ", all(a));
#define deb(x...) cerr << setw(4) << __LINE__ << ":[" #x "]: ", [](auto... arg_) { (( cerr << arg_ << ", " ), ...) << '\n'; }(x)
#else
#define deb(...) 0
#endif

void solve() {

}

int32_t main() {
    cin.tie(0)->sync_with_stdio(0);
    cout << fixed << setprecision(10);

    int z = 1;
    // cin >> z;
    rep(_, z) solve();

    cout << flush;
    _Exit(0);
}
