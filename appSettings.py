from string import Template

def initCapital(s):
    return s[0].upper() + s[1:]

class Prpt:
    field_type = ""
    p_name = ""
    is_constant = False
    p_default_val = """"""

    def __init__(self, field_type, p_name,p_default_val=""""""):
        self.field_type = field_type
        self.p_name = p_name
        self.p_default_val = p_default_val
        
    def get_p_initCapital(self):
        return initCapital(self.p_name)

    def getQ_Property(self):
        field_type = self.field_type
        p = self.p_name
        p_capitalize = self.get_p_initCapital()
        if self.is_constant:
            t = Template("""
            Q_PROPERTY( ${field_type} $p READ $p CONSTANT)""")
            return t.substitute(p=p,
                field_type=field_type, p_capitalize=p_capitalize)

        else:
            t = Template("""
            Q_PROPERTY( ${field_type} $p READ $p WRITE set${p_capitalize} NOTIFY ${p}Changed)""")
            return t.substitute(p=p,
                field_type=field_type, p_capitalize=p_capitalize)

    def getQ_header_private(self):
        field_type = self.field_type
        p = self.p_name
        if self.is_constant:
            return ""
        else:
            t = Template("""
            ${field_type} m_$p;""")
            return t.substitute(p=p,
                field_type=field_type)                

    def getQ_header_signal(self):
        field_type = self.field_type
        p = self.p_name
        if self.is_constant:
            return ""
        else:
            t = Template("""
            void ${p}Changed();""")
            return t.substitute(p=p)

    def getQ_header_public(self):
        field_type = self.field_type
        p = self.p_name
        p_capitalize = self.get_p_initCapital()
        if self.is_constant:
            return ""
        else:
            if field_type == "QString":
                t = Template("""
                const QString ${p}() const;
                void set${p_capitalize}(const QString &${p});""")
                return t.substitute(p=p,p_capitalize=p_capitalize)
            elif field_type == "bool" or field_type == "int":
                t = Template("""
                ${field_type} ${p}() const { return m_${p}; };
                void set${p_capitalize}(const ${field_type} ${p});""")
                return t.substitute(p=p,p_capitalize=p_capitalize,field_type=field_type)            
            else:
                return ""

    def getQ_src_contr(self):
        field_type = self.field_type
        p = self.p_name
        p_capitalize = self.get_p_initCapital()
        if self.is_constant:
            return ""
        else:
            if field_type == "QString":
                t = Template("""
                m_${p} = settings.value("${p}", "").toString();""")
                return t.substitute(p=p)
            elif field_type == "bool":
                p_default = self.p_default_val
                t = Template("""
                m_${p} = settings.value("${p}", ${p_default}).toBool();""")
                return t.substitute(p=p,p_default=p_default)    
            elif field_type == "int":
                p_default = self.p_default_val
                t = Template("""
                m_${p} = settings.value("${p}", ${p_default}).toInt();""")
                return t.substitute(p=p,p_default=p_default)                    
            else:
                return ""

a = [
    Prpt("QString",'passwordStorePath'),
    Prpt("QString",'tmpFolderPath'),
    Prpt("QString",'gitExecPath'),
    Prpt("QString",'vscodeExecPath'),
    Prpt("QString",'autoTypeCmd'),
    Prpt("QString",'ctxSigner'),
    Prpt("QString",'fontSize'),
    Prpt("QString",'commitMsg'),
    Prpt("QString",'binaryExts'),
    Prpt("bool",'useClipboard',"false"),
    Prpt("bool",'doSign',"false"),
    Prpt("bool",'preferYamlView',"true"),    
    Prpt("bool",'isFindMemCash',"false"),
    Prpt("bool",'isFindSlctFrst',"false"),
    Prpt("bool",'isShowPreview',"true"),
    Prpt("int",'openWith',"0"),
]   

p = Prpt("QString",'appVer')
p.is_constant = True
a.append(p)
    



def getQ_Properties():
    s=""
    for row in a:
        s = s + row.getQ_Property()
    return s

def getQ_header_privates():
    s=""
    for row in a:
        s = s + row.getQ_header_private()
    return s      

def getQ_header_signals():
    s=""
    for row in a:
        s = s + row.getQ_header_signal()
    return s    

def getQ_header_publics():
    s=""
    for row in a:
        s = s + row.getQ_header_public()
    return s   



def getQ_src_contrs():
    s=""
    for row in a:
        s = s + row.getQ_src_contr()
    return s        
"""
remarks
print(getQ_Properties())
print(getQ_header_privates())
print(getQ_header_signals())
print(getQ_header_publics())
print(getQ_src_contrs())
"""

