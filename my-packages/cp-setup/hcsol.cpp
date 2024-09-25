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
#define DTP(x, y) auto operator << (auto &o, auto a) -> decltype(y, o) { o << "("; x; return o << ")"; }
DTP(o << a.st << ", " << a.nd, a.nd);
DTP(for (auto i : a) o << i << ", ", all(a));
#define deb(x...) cerr << setw(4) << __LINE__ << ":[" #x "]: ", [](auto... y) { (( cerr << y << ", " ), ...) << '\n'; }(x)

struct Task {
    int ans;
    Task() {
    }
    void run() {
    }
    void report() {
        cout << ans << '\n';
    }
};

const set<ll> interesting_cases = {};

ll& get_case_id() {
    static map<thread::id, ll> thread_map;
    static mutex error_mutex;
    lock_guard lock(error_mutex);
    return thread_map[this_thread::get_id()];
}

int main() {
    cin.tie(0)->sync_with_stdio(0);
    cout << fixed << setprecision(10);
    signal(SIGABRT, [](int) {
        cout << "Assert from case #" << get_case_id() << endl;
        _Exit(1);
    });
    signal(SIGSEGV, [](int) {
        cout << "Segfault from case #" << get_case_id() << endl;
        _Exit(1);
    });
    auto skip_case = [&](ll c) {
        return sz(interesting_cases) && !interesting_cases.count(c);
    };

    int z;
    cin >> z;

    #ifdef LOCF
    auto start_time = chrono::high_resolution_clock::now();
    assert(sz(interesting_cases) || !isatty(STDOUT_FILENO));
    for (int l = 1; l <= z;) {
        vector<Task> tasks(min(z - l + 1, (int)thread::hardware_concurrency()));
        vector<jthread> threads;
        for (auto [id, task] : tasks | views::enumerate) threads.eb([&]{
            if (skip_case(get_case_id() = l + id)) return;
            task.run();
        });
        threads.clear();
        for (auto &task : tasks) if (!skip_case(l++)) {
            cout << "Case #" << l - 1 << ": ";
            task.report();
            cout << flush;
        }
        if (interesting_cases.empty()) {
            auto time_here = chrono::high_resolution_clock::now();
            auto time_diff = chrono::duration_cast<chrono::seconds>(time_here - start_time);
            cerr << "Finished case #" << l - 1 << " out of " << z << " (took " << time_diff << ")\n";
        }
    }

    cout.flush(); cerr << "- - - - - - - - -\n";
    (void)!system("grep VmPeak /proc/$PPID/status | sed s/....kB/\' MB\'/1 >&2"); // 4x.kB ....kB

    #else

    fwd(l, 1, z + 1) {
        Task task;
        if (skip_case(l))
            continue;
        get_case_id() = l;
        task.run();
        cout << "Case #" << l << ": ";
        task.report();
        cout << flush;
    }

    #endif
}
