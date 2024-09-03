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

struct ElfFile {
    int offset_;
    string data_;

    static ElfFile load_from_file(string file) {
        ifstream ifs(file);
        stringstream buffer;
        buffer << ifs.rdbuf();
        return {0x08047000, buffer.str()};
    }
    void save_to_file(string file) {
        ofstream(file) << data_;
    }
    char &operator[](int i) {
        return data_[i - offset_];
    }
    int L() { 
        return offset_; 
    }
    int R() { 
        return offset_ + sz(data_); 
    }
    string sub(int lpos, int count) { 
        return data_.substr(lpos - offset_, count); 
    }
    vi find(string txt) {
        vi ids;
        fwd(i, L(), R() + 1) 
            if (sub(i, sz(txt)) == txt)
                ids.pb(i);
        return ids;
    }
    void write(int pos, string text) {
        rep(i, sz(text))
            operator[](pos + i) = text[i];
    }
};

string from_addr(int pos) {
    char *p = reinterpret_cast<char*>(&pos);
    return ""s + p[0] + p[1] + p[2] + p[3];
}

void fix_elf_string(ElfFile &elf, int pos, string new_text) {
    auto used_at = elf.find(from_addr(pos));
    new_text = new_text + &elf[pos];
    deb(pos, used_at, new_text);

    int new_pos = elf.find(string(sz(new_text) + 100, '\0'))[0] + 50;
    elf.write(new_pos, new_text);

    for (int i : used_at)
        elf.write(i, from_addr(new_pos));
}

int32_t main(int, char **argv) {
    string prefix_before = argv[1];
    string added_prefix = argv[2];
    string base_file = argv[3];
    string new_file = argv[4];

    auto elf = ElfFile::load_from_file(base_file);
    cerr << hex;

    auto occ = elf.find(prefix_before);
    deb(occ);

    for (auto a : occ) 
        fix_elf_string(elf, a, added_prefix);

    occ = elf.find(prefix_before);
    deb(occ);

    elf.save_to_file(new_file);
}
