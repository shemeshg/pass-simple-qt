from string import Template

def initCapital(s):
    return s[0].upper() + s[1:]

class Prpt:
    field_type = ""
    p_name = ""
    qliststr_already_string = False

    def __init__(self, field_type, p_name, qliststr_already_string=False):
        self.field_type = field_type
        self.p_name = p_name
        self.qliststr_already_string = qliststr_already_string

    def getQ_Property(self):
        field_type = self.field_type
        p = self.p_name
        t = Template("""
         Q_PROPERTY(${field_type} ${p} READ ${p} CONSTANT)""")
        return t.substitute(p=p,
            field_type=field_type)

    def getQ_header_public(self):
        field_type = self.field_type
        p = self.p_name
        if field_type == "QStringList":
            t = Template("""
            QStringList ${p}() const;""")
            return t.substitute(p=p)     
        elif field_type == "QString":
            t = Template("""
            const QString ${p}() const { return QString::fromStdString(m_gpgIdManage->${p}); };""")
            return t.substitute(p=p)     
        elif field_type == "bool":  
            t = Template("""
            bool ${p}() const { return m_gpgIdManage->${p}; };""")
            return t.substitute(p=p)                                

    def get_src_QList(self):
        field_type = self.field_type
        p = self.p_name
        get_key_str = ".getKeyStr()"
        if self.qliststr_already_string:
            get_key_str = ""
        t = Template("""
QStringList GpgIdManageType::${p}() const
{
    QStringList l;
    for (auto r : m_gpgIdManage->${p}) {
        l.append(QString::fromStdString(r${get_key_str}));
    }
    return l;
}""")
        return t.substitute(p=p,get_key_str=get_key_str)

def getQ_Properties():
    s=""
    for row in a:
        s = s + row.getQ_Property()
    return s

def getQ_header_publics():
    s=""
    for row in a:
        s = s + row.getQ_header_public()
    return s

def getQ_src_publics():
    s=""
    for row in a:
        if row.field_type == "QStringList":
            s = s + row.get_src_QList()
    return s


a = [
    Prpt("QString",'currentPath'),
    Prpt("QString",'stopPath'),
    Prpt("QString",'nearestGpgIdFolder'),
    Prpt("QString",'gpgPubKeysFolder'),
    Prpt("QString",'nearestGpgIdFile'),
    Prpt("QStringList",'keysNotFoundInGpgIdFile',True),
    Prpt("QStringList",'keysFoundInGpgIdFile'),
    Prpt("QStringList",'allKeys'),
    Prpt("QStringList",'allPrivateKeys'),
    Prpt("bool",'gpgPubKeysFolderExists'),
    Prpt("bool",'classInitialized'),
]
"""
remarks
print(getQ_Properties())
print(getQ_header_publics())
print(getQ_src_publics())
"""

