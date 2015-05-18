##import ConfigParser


##NOTE: Files must have an empty line at the end
endline = '\t}\n\n'

#Armor Types: - "CombatClassDefend"
#------------
armortypes = {}
armortypes['Flesh'] = 'DOTA_COMBAT_CLASS_DEFEND_SOFT'
armortypes['small'] = 'DOTA_COMBAT_CLASS_DEFEND_WEAK'
armortypes['medium'] = 'DOTA_COMBAT_CLASS_DEFEND_BASIC'
armortypes['large'] = 'DOTA_COMBAT_CLASS_DEFEND_STRONG'
armortypes['fort'] = 'DOTA_COMBAT_CLASS_DEFEND_STRUCTURE'
armortypes['hero'] = 'DOTA_COMBAT_CLASS_DEFEND_HERO'
armortypes['none'] = 'NONE'
armortypes['divine'] = 'DIVINE'


#Attack Types: - "CombatClassAttack"
#--------------
attacktypes = {}
attacktypes['normal'] = 'DOTA_COMBAT_CLASS_ATTACK_BASIC'
attacktypes['pierce'] = 'DOTA_COMBAT_CLASS_ATTACK_PIERCE'
attacktypes['siege'] = 'DOTA_COMBAT_CLASS_ATTACK_SIEGE'
attacktypes['chaos'] = 'DOTA_COMBAT_CLASS_ATTACK_LIGHT'
attacktypes['hero'] = 'DOTA_COMBAT_CLASS_ATTACK_HERO'
attacktypes['magic'] = 'MAGIC_MAN'
attacktypes['spells'] = 'ONLYSPELLS'

#Movement Types: - ""
#--------------
movementtypes = {}
movementtypes['foot'] = 'DOTA_UNIT_CAP_MOVE_GROUND'
movementtypes['fly'] = 'DOTA_UNIT_CAP_MOVE_FLY'
movementtypes['float'] = 'DOTA_UNIT_CAP_MOVE_GROUND'
movementtypes['hover'] = 'DOTA_UNIT_CAP_MOVE_GROUND'
movementtypes['_'] = 'DOTA_UNIT_CAP_MOVE_NONE'
movementtypes[''] = 'DOTA_UNIT_CAP_MOVE_NONE'
movementtypes['amph'] = 'DOTA_UNIT_CAP_MOVE_GROUND'
movementtypes['horse'] = 'DOTA_UNIT_CAP_MOVE_GROUND'
class wc3pars:
    def __init__(self, section):
        self.npc_name = ''
        if 'Name' in section:
            self.npc_name = section['Name']
        
        self.baseclass = 'npc_dota_creature'
        self.level = 1
        if 'level' in section:
            self.level = section['level']

        self.abilitycounter = 1
        self.abilitylist = None
        if 'abilList' in section:
            if section['abilList'] is not '_':
                self.abilitylist = section['abilList']
                self.abilitylist = self.abilitylist.split(',')
        self.heroabilitylist = None
        if 'heroAbilList' in section:
            if section['heroAbilList'] is not '':
                self.heroabilitylist = section['heroAbilList']
                self.heroabilitylist = self.heroabilitylist.split(',')

        self.combatclassdefend = 'DOTA_COMBAT_CLASS_DEFEND_BASIC'
        if 'defType' in section:
            self.combatclassdefend = armortypes[section['defType']]
        self.armorphys = None
        if 'def' in section:
            self.armorphys = section['def']
        self.armormagic = 0

        self.attackcapabilities = 'DOTA_UNIT_CAP_MELEE_ATTACK'
        self.attackdamagemin = None
        self.attackdamagemax = None
        if (('dice1' and 'sides1') in section):
            if section['dice1'] is not '-' and section['sides1'] is not '-':
                self.attackdamagemin = str(float(section['dice1']) + float(section['dmgplus1']))
                self.attackdamagemax = str(float(section['dice1']) * float(section['sides1']) + float(section['dmgplus1']))
        self.attackdamagetype = 'DAMAGE_TYPE_PHYSICAL'
        self.attackrate = None
        if 'cool1' in section:
            self.attackrate = section['cool1']
        self.attackanimationpoint = None
        if 'dmgpt1' in section:
            self.attackanimationpoint = section['dmgpt1']
        self.attackacqurange = None
        if 'acquire' in section:
            self.attackacqurange = section['acquire']
        self.attackrange = None
        if 'rangeN1' in section:
            self.attackrange = section['rangeN1']

        self.projectilemodel = None
        self.projectilespeed = None
        if 'Missilespeed' in section:
            if section['Missilespeed'] is not '':
                self.projectilemodel = ''
                self.projectilespeed = section['Missilespeed']
                self.attackcapabilities = 'DOTA_UNIT_CAP_RANGED_ATTACK'
        
        self.combatclassattack = 'DOTA_COMBAT_CLASS_ATTACK_BASIC'
        if 'atkType1' in section:
            if section['atkType1'] is not 'none':
                self.combatclassattack = attacktypes[section['atkType1']]
            else:
                self.combatclassattack = None
                self.attackcapabilities = 'DOTA_UNIT_CAP_NO_ATTACK'

        self.bountygoldmin = None
        self.bountygoldmax = None
        if 'bountydice' in section:
            self.bountygoldmin = str(float(section['bountydice']) + float(section['bountyplus']))
            self.bountygoldmax = str(float(section['bountydice']) * float(section['bountysides']) + float(section['bountyplus']))

        self.statushealth= None
        if 'HP' in section:
            self.statushealth = section['HP']
        self.statushealthregen = None
        if 'regenHP' in section:
            if section['regenHP'] is not '-':
                self.statushealthregen = section['regenHP']
        self.statusmana = None
        if 'manaN' in section:
            if section['manaN'] is not '-':
                self.statusmana = section['manaN']
        self.statusmanaregen = None
        if 'regenMana' in section:
            if section['regenMana'] is not ' - ':
                self.statusmanaregen = section['regenMana']

        self.team = 'DOTA_TEAM_BADGUYS'
        self.unitrelationshipclass = 'DOTA_NPC_UNIT_RELATIONSHIP_TYPE_DEFAULT'
        self.visiondaytimerange = 10
        if 'sight' in section:
            self.visiondaytimerange = section['sight']
        self.visionnighttimerange = 10
        if 'nsight' in section:
            self.visionnighttimerage = section['nsight']

        self.movementcapabilities = None
        self.movementspeed = None
        if 'spd' in section:
            self.movementspeed = section['spd']
            if 'movetp' in section:
                self.movementcapabilities = movementtypes[section['movetp']]
        self.movementturnrate = None
        if 'turnRate' in section:
            self.movementturnrate = section['turnRate']
        self.boundshullname = 'DOTA_HULL_SIZE_HERO'
        self.healthbaroffset = 140

        self.comments = ''
        
        self.discription = None
        if 'Ubertip' in section:
            self.discription = section['Ubertip']

    def check(self):
        print(self.npc_name)
        print(self.statushealthregen)
        print(self.statusmanaregen)

    def writetofile(self, nfile, write):  ##if you need to edit the format or spelling or whatever, do it here
        newfile = open(nfile, write)
        lines = []
        section = ''
        lines.append('\n')
        lines.append(self.unitcomment(self.npc_name))
        lines.append(self.kline(self.npc_name.replace(' ', '_')))
        lines.append(self.kvcomment(' General'))
        lines.append(self.kvcomment('----------------------------------------------------------------'))
        lines.append(self.kvline('BaseClass', self.baseclass,None))
        lines.append(self.kvline('Model', '', 'Needs model data'))
        lines.append(self.kvline('ModelScale', '1', None))
        lines.append(self.kvline('Level', self.level, None))
        lines.append(self.kvcomment(None))
        
        lines.append(self.kvcomment(' Abilities'))
        lines.append(self.kvcomment('----------------------------------------------------------------'))
        if self.abilitylist is not None:
            for abil in self.abilitylist:
                lines.append(self.kvline('Ability' + str(self.abilitycounter), '', 'Reference: ' + abil))
                self.abilitycounter += 1
        if self.heroabilitylist is not None:
            for abil in self.heroabilitylist:
                lines.append(self.kvline('Ability' + str(self.abilitycounter), '', 'Reference: ' + abil))
                self.abilitycounter += 1
        lines.append(self.kvcomment(None))

        lines.append(self.kvcomment(' Armor'))
        lines.append(self.kvcomment('----------------------------------------------------------------'))
        lines.append(self.kvline('ArmorPhysical', self.armorphys, None))
        lines.append(self.kvline('MagicalResistance', self.armormagic, None))
        lines.append(self.kvcomment(None))

        lines.append(self.kvcomment(' Attack'))
        lines.append(self.kvcomment('----------------------------------------------------------------'))
        lines.append(self.kvline('AttackCapabilities',self.attackcapabilities, None))
        lines.append(self.kvline('AttackDamageMin', self.attackdamagemin, None))
        lines.append(self.kvline('AttackDamageMax', self.attackdamagemax, None))
        lines.append(self.kvline('AttackDamageType', self.attackdamagetype, None))
        lines.append(self.kvline('AttackRate', self.attackrate, None))
        lines.append(self.kvline('AttackAnimationPoint',self.attackanimationpoint, None))
        lines.append(self.kvline('AttackAcquisitionRange', self.attackacqurange, None))
        lines.append(self.kvline('AttackRange',self.attackrange, None))
        lines.append(self.kvline('ProjectileModel', self.projectilemodel, 'Add projectile models'))
        lines.append(self.kvline('ProjectileSpeed', self.projectilespeed, None))
        lines.append(self.kvcomment(None))

        lines.append(self.kvcomment(' Bounty'))
        lines.append(self.kvcomment('----------------------------------------------------------------'))
        lines.append(self.kvline('BountyGoldMin', self.bountygoldmin, None))
        lines.append(self.kvline('BountyGoldMax', self.bountygoldmax, None))
        lines.append(self.kvcomment(None))

        lines.append(self.kvcomment(' Movement'))
        lines.append(self.kvcomment('----------------------------------------------------------------'))
        lines.append(self.kvline('MovementCapabilities', self.movementcapabilities, None))
        lines.append(self.kvline('MovementSpeed', self.movementspeed, None))
        lines.append(self.kvline('MovementTurnRate', self.movementturnrate, None))
        lines.append(self.kvcomment(None))

        lines.append(self.kvcomment(' Status'))
        lines.append(self.kvcomment('----------------------------------------------------------------'))
        lines.append(self.kvline('StatusHealth', self.statushealth, None))
        lines.append(self.kvline('StatusHealthRegen', self.statushealthregen, None))
        lines.append(self.kvline('StatusMana', self.statusmana, None))
        lines.append(self.kvline('StatsManaRegen', self.statusmanaregen, None))
        lines.append(self.kvcomment(None))

        lines.append(self.kvcomment(' Vision'))
        lines.append(self.kvcomment('----------------------------------------------------------------'))
        lines.append(self.kvline('VisionDaytimeRange', self.visiondaytimerange, None))
        lines.append(self.kvline('VisionNighttimeRange', self.visionnighttimerange, None))
        lines.append(self.kvcomment(None))
        
        lines.append(self.kvcomment(' Team'))
        lines.append(self.kvcomment('----------------------------------------------------------------'))
        lines.append(self.kvline('TeamName', self.team, None))
        lines.append(self.kvline('CombatClassAttack', self.combatclassattack, None))
        lines.append(self.kvline('CombatClassDefened', self.combatclassdefend, None))
        lines.append(self.kvline('UnitRelationShipClass', self.unitrelationshipclass, None))
        lines.append(self.kvcomment(None))

        
        lines.append(self.kvline('BoundsHullName', self.boundshullname, None))
        lines.append(self.kvline('HealthBarOffset', self.healthbaroffset, None))
        lines.append(self.kvcomment(None))

        lines.append(self.kvcomment(' Creature Data'))
        lines.append(self.kvcomment('----------------------------------------------------------------'))
        lines.append(endline)
        for line in lines:
            section += line
        newfile.write(section)

    def kvline(self, key, val, comment):
        line = ''
        if val is not None:
            key = str(key)
            val = str(val)
            line = '\t\t"' + key + '"\t'
            if len(key) < 6:
                line += '\t'
            if len(key) < 14:
                line += '\t'
            if len(key) < 22:
                line += '\t'
            line += '"' + val +'"'
            if comment is not None:
                line += '\t //' + comment
            line += '\n'
        return line

    def kvcomment(self, comment):
        line =  '\t\t'
        if comment is not None:
            line += '//' + comment
        line += '\n'
        return line

    def unitcomment(self, comment):
        line = '\t//=================================================================================\n'
        line += '\t// Creature: ' + comment +'\n'
        if self.discription is not None:
            line += '\t// Discription: ' + self.discription + '\n'
        line += '\t//=================================================================================\n'
        return line

    def kline(self, unit_name):
        line = '\t"'+ unit_name +'"\n' + '\t{\n'
        return line
        

def parse_file_section(textsec):
    lines = {}
    counter = 0
    with open(textsec) as f:
        for line in f:
            pair = line[0:-1].split('=')
            if len(pair) == 2:
                lines[pair[0]] = pair[1]
    return lines

def parse_text_section(textsec):
    textsec = textsec.split('\n')
    lines = {}
    counter = 0
    for line in textsec:
        pair = line.split('=')
        if len(pair) == 2:
            lines[pair[0]] = pair[1]
    return lines

def sectionoff(textfile):
    sections = {}
    with open(textfile, 'r') as f:
        secname = ''
        sec = ''
        for line in f:
            if line[0:1] == '[':
                sections[secname] = sec
                secname = line
                secname = secname[1:-2]
                sec = ''
            else:
                sec += line
    return sections


if __name__ == '__main__':
    fullfile = sectionoff('units_copy.txt')
    print(fullfile[''])
    f = open('parsed.txt','w')
    f.write('')
    for key in fullfile:
        if key is not '':
            afile = parse_text_section(fullfile[key])
            work = wc3pars(afile)
            work.writetofile('parsed.txt', 'a')
            #print(work.projectilespeed)
    print('finished')
