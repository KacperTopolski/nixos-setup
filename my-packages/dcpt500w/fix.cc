#include <fstream>
#include <vector>
#include <string>
#include <sstream>
#include <algorithm>

const int OFFSET = 0x08047000;
const int SAFE_DIST = 50;

struct ElfFile {
    std::string data_;

    static ElfFile load_from_file(std::string file) {
        std::ifstream ifs(file);
        std::stringstream buffer;
        buffer << ifs.rdbuf();
        return {buffer.str()};
    }
    void save_to_file(std::string file) {
        std::ofstream(file) << data_;
    }
    char &operator[](int i) {
        return data_.at(i - OFFSET);
    }
    int L() { 
        return OFFSET; 
    }
    int R() { 
        return OFFSET + (int)data_.size(); 
    }
};

std::string from_addr(int pos) {
    char *p = reinterpret_cast<char*>(&pos);
    return std::string(p, p + 4);
}

std::vector<int> elf_find_all(ElfFile &elf, std::string txt) {
    std::vector<int> ids;
    for (int i = elf.L(); i <= elf.R() - (int)txt.size(); ++i)
        if (std::equal(txt.begin(), txt.end(), &elf[i]))
            ids.push_back(i);
    return ids;
}

void elf_fix_string(ElfFile &elf, int pos, std::string new_text) {
    auto used_at = elf_find_all(elf, from_addr(pos));
    new_text += &elf[pos];

    int new_pos = elf_find_all(elf, std::string(new_text.size() + SAFE_DIST * 2, '\0'))[0] + SAFE_DIST;
    std::copy(new_text.begin(), new_text.end(), &elf[new_pos]);

    auto new_pos_str = from_addr(new_pos);
    for (int i : used_at)
        std::copy(new_pos_str.begin(), new_pos_str.end(), &elf[i]);
}

int main(int, char **argv) {
    std::string prefix_before = argv[1];
    std::string added_prefix = argv[2];
    std::string base_file = argv[3];
    std::string new_file = argv[4];

    auto elf = ElfFile::load_from_file(base_file);
    auto positions = elf_find_all(elf, prefix_before);

    for (auto p : positions) 
        elf_fix_string(elf, p, added_prefix);

    elf.save_to_file(new_file);
    return 0;
}
