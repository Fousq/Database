# Report on indexes

## Without index

1. Script "Find student by name (exact match)":
    * Seq Scan on student  (cost=0.00..2402.00 rows=25 width=66) (actual time=0.011..8.411 rows=38 loops=1):
        * Filter: ((name)::text = 'Sion'::text)
        * Rows Removed by Filter: 99962
    * Planning Time: 0.640 ms
    * Execution Time: 8.425 ms
2. Script "Find student by surname (partial match)":
    * Seq Scan on student  (cost=0.00..2402.00 rows=9 width=66) (actual time=0.016..11.306 rows=445 loops=1):
        * Filter: ((surname)::text ~~ '%ock%'::text)
        * Rows Removed by Filter: 99555
    * Planning Time: 0.698 ms
    * Execution Time: 11.343 ms
3. Script "Find student by phone number (partial match)":
    * Seq Scan on student  (cost=0.00..2402.00 rows=10 width=66) (actual time=0.013..14.883 rows=7 loops=1):
        * Filter: (phone ~~ '%2401%'::text)
        * Rows Removed by Filter: 99993
    * Planning Time: 0.070 ms
    * Execution Time: 14.896 ms
4. Script "Find student with marks by student's surname (partial match)":
    * Gather  (cost=2887.36..1166776.92 rows=9000 width=17) (actual time=21.244..67608.825 rows=445000 loops=1):
        * Workers Planned: 2
        * Workers Launched: 2
        * Parallel Hash Join  (cost=1887.36..1164876.92 rows=3750 width=17) (actual time=21.179..67520.499 rows=148333 loops=3):
            * Hash Cond: (exam_result.student_id = student.id)
            * Parallel Seq Scan on exam_result  (cost=0.00..1053609.87 rows=41666687 width=12) (actual time=0.291..64765.230 rows=33333333 loops=3):
                * Parallel Hash  (cost=1887.29..1887.29 rows=5 width=21) (actual time=5.769..5.769 rows=148 loops=3):
                    * Buckets: 1024  Batches: 1  Memory Usage: 40kB
                    * Parallel Seq Scan on student  (cost=0.00..1887.29 rows=5 width=21) (actual time=0.009..17.102 rows=445 loops=1):
                        * Filter: ((surname)::text ~~ '%ock%'::text)
                        * Rows Removed by Filter: 99555
    * Planning Time: 2.345 ms
    * Execution Time: 67618.840 ms

## Using index B-tree

1. Script "Find student by name (exact match)":
    * Bitmap Heap Scan on student  (cost=4.61..93.88 rows=25 width=66) (actual time=0.040..0.074 rows=38 loops=1):
        * Recheck Cond: ((name)::text = 'Sion'::text)
        * Heap Blocks: exact=38
        * Bitmap Index Scan on student_name_index  (cost=0.00..4.61 rows=25 width=0) (actual time=0.032..0.032 rows=38 loops=1):
            * Index Cond: ((name)::text = 'Sion'::text)
    * Planning Time: 0.083 ms
    * Execution Time: 0.101 ms
2. Script "Find student by surname (partial match)":
    * Seq Scan on student  (cost=0.00..2402.00 rows=9 width=66) (actual time=0.014..12.245 rows=445 loops=1):
        * Filter: ((surname)::text ~~ '%ock%'::text)
        * Rows Removed by Filter: 99555
    * Planning Time: 1.190 ms
    * Execution Time: 12.269 ms
3. Script "Find student by phone number (partial match)":
    * Seq Scan on student  (cost=0.00..2402.00 rows=10 width=66) (actual time=0.014..14.616 rows=7 loops=1):
        * Filter: (phone ~~ '%2401%'::text)
        * Rows Removed by Filter: 99993
    * Planning Time: 0.095 ms
    * Execution Time: 14.630 ms
4. Script "Find student with marks by student's surname (partial match)" create index on exam_result.student_id:
    * Nested Loop  (cost=0.57..4597.71 rows=9000 width=17) (actual time=0.036..153.295 rows=445000 loops=1)
        * Seq Scan on student  (cost=0.00..2402.00 rows=9 width=21) (actual time=0.020..13.871 rows=445 loops=1): 
            * Filter: ((surname)::text ~~ '%ock%'::text)
            * Rows Removed by Filter: 99555
            * Index Scan using exam_result_student_id_index on exam_result  (cost=0.57..206.37 rows=3760 width=12) (actual time=0.039..0.220 rows=1000 loops=445):
                * Index Cond: (student_id = student.id)
    * Planning Time: 7.402 ms
    * Execution Time: 162.861 ms
5. Script "Find student with marks by student's surname (partial match)" create index on exam_result.student_id and student.id:
    * Nested Loop  (cost=0.57..4597.71 rows=9000 width=17) (actual time=0.024..98.302 rows=445000 loops=1):
        * Seq Scan on student  (cost=0.00..2402.00 rows=9 width=21) (actual time=0.013..11.674 rows=445 loops=1):
            * Filter: ((surname)::text ~~ '%ock%'::text)
            * Rows Removed by Filter: 99555
            * Index Scan using exam_result_student_id_index on exam_result  (cost=0.57..206.37 rows=3760 width=12) (actual time=0.005..0.108 rows=1000 loops=445):
                * Index Cond: (student_id = student.id)
    * Planning Time: 0.222 ms
    * Execution Time: 106.907 ms

## Using Hash index

1. Script "Find student by name (exact match)":
    * Bitmap Heap Scan on student  (cost=4.19..93.46 rows=25 width=66) (actual time=0.036..0.067 rows=38 loops=1):
        * Recheck Cond: ((name)::text = 'Sion'::text)
        * Heap Blocks: exact=38
        * Bitmap Index Scan on student_name_index  (cost=0.00..4.19 rows=25 width=0) (actual time=0.027..0.027 rows=38 loops=1):
            * Index Cond: ((name)::text = 'Sion'::text)
    * Planning Time: 1.072 ms
    * Execution Time: 0.092 ms
2. Script "Find student by surname (partial match)":
    * Seq Scan on student  (cost=0.00..2402.00 rows=9 width=66) (actual time=0.013..11.663 rows=445 loops=1):
        * Filter: ((surname)::text ~~ '%ock%'::text)
        * Rows Removed by Filter: 99555
    * Planning Time: 1.064 ms
    * Execution Time: 11.686 ms
3. Script "Find student by phone number (partial match)":
    * Seq Scan on student  (cost=0.00..2402.00 rows=10 width=66) (actual time=0.013..14.901 rows=7 loops=1):
        * Filter: (phone ~~ '%2401%'::text)
        * Rows Removed by Filter: 99993
    * Planning Time: 1.228 ms
    * Execution Time: 14.914 ms
4. Script "Find student with marks by student's surname (partial match)" create index on exam_result.student_id:
    * Gather  (cost=1109.43..61229.69 rows=9000 width=17) (actual time=1.199..393.887 rows=445000 loops=1):
        * Workers Planned: 2
        * Workers Launched: 2
        * Nested Loop  (cost=109.43..59329.69 rows=3750 width=17) (actual time=1.870..286.109 rows=148333 loops=3):
            * Parallel Index Scan using student_pkey on student  (cost=0.29..3280.13 rows=4 width=21) (actual time=0.539..75.043 rows=148 loops=3):
                * Filter: ((surname)::text ~~ '%ock%'::text)
                * Rows Removed by Filter: 33185
                * Bitmap Heap Scan on exam_result  (cost=109.14..13974.79 rows=3760 width=12) (actual time=0.424..1.319 rows=1000 loops=445):
                    * Recheck Cond: (student_id = student.id)
                    * Heap Blocks: exact=1057
                    * Bitmap Index Scan on exam_result_student_id_index  (cost=0.00..108.20 rows=3760 width=0) (actual time=0.081..0.081 rows=1000 loops=445):
                        * Index Cond: (student_id = student.id)
    * Planning Time: 7.762 ms
    * Execution Time: 404.408 ms
5. Script "Find student with marks by student's surname (partial match)" create index on exam_result.student_id and student.id:
    * Gather  (cost=1109.43..61229.69 rows=9000 width=17) (actual time=0.777..145.139 rows=445000 loops=1):
        * Workers Planned: 2
        * Workers Launched: 2
        * Nested Loop  (cost=109.43..59329.69 rows=3750 width=17) (actual time=0.123..52.423 rows=148333 loops=3):
            * Parallel Index Scan using student_pkey on student  (cost=0.29..3280.13 rows=4 width=21) (actual time=0.050..8.464 rows=148 loops=3):
                * Filter: ((surname)::text ~~ '%ock%'::text)
                * Rows Removed by Filter: 33185
                    * Bitmap Heap Scan on exam_result  (cost=109.14..13974.79 rows=3760 width=12) (actual time=0.045..0.185 rows=1000 loops=445):
                        * Recheck Cond: (student_id = student.id)
                        * Heap Blocks: exact=1362
                            * Bitmap Index Scan on exam_result_student_id_index  (cost=0.00..108.20 rows=3760 width=0) (actual time=0.040..0.040 rows=1000 loops=445):
                                * Index Cond: (student_id = student.id)
    * Planning Time: 1.046 ms
    * Execution Time: 156.616 ms

## Using Gin index

1. Script "Find student by name (exact match)":
    * Bitmap Heap Scan on student  (cost=12.19..101.46 rows=25 width=66) (actual time=0.038..0.067 rows=38 loops=1):
        * Recheck Cond: ((name)::text = 'Sion'::text)
        * Heap Blocks: exact=38
        * Bitmap Index Scan on student_name_index  (cost=0.00..12.19 rows=25 width=0) (actual time=0.032..0.032 rows=38 loops=1):
            * Index Cond: ((name)::text = 'Sion'::text)
    * Planning Time: 1.103 ms
    * Execution Time: 0.106 ms
2. Script "Find student by surname (partial match)":
    * Seq Scan on student  (cost=0.00..2402.00 rows=9 width=66) (actual time=0.013..11.785 rows=445 loops=1):
        * Filter: ((surname)::text ~~ '%ock%'::text)
        * Rows Removed by Filter: 99555
    * Planning Time: 1.059 ms
    * Execution Time: 11.809 ms
3. Script "Find student by phone number (partial match)":
    * Seq Scan on student  (cost=0.00..2402.00 rows=10 width=66) (actual time=0.013..17.930 rows=7 loops=1):
        * Filter: (phone ~~ '%2401%'::text)
        * Rows Removed by Filter: 99993
    * Planning Time: 1.036 ms
    * Execution Time: 17.943 ms
4. Script "Find student with marks by student's surname (partial match)" create index on exam_result.student_id:
    * Gather  (cost=1045.88..60975.48 rows=9000 width=17) (actual time=1.212..150.431 rows=445000 loops=1):
        * Workers Planned: 2
        * Workers Launched: 2
        * Nested Loop  (cost=45.88..59075.48 rows=3750 width=17) (actual time=0.737..65.005 rows=148333 loops=3):
            * Parallel Index Scan using student_pkey on student  (cost=0.29..3280.13 rows=4 width=21) (actual time=0.516..12.215 rows=148 loops=3):
                * Filter: ((surname)::text ~~ '%ock%'::text)
                * Rows Removed by Filter: 33185
                * Bitmap Heap Scan on exam_result  (cost=45.59..13911.24 rows=3760 width=12) (actual time=0.115..0.253 rows=1000 loops=445):
                    * Recheck Cond: (student_id = student.id)
                    * Heap Blocks: exact=1432
                    * Bitmap Index Scan on exam_result_student_id_index  (cost=0.00..44.65 rows=3760 width=0) (actual time=0.092..0.092 rows=1000 loops=445):
                        * Index Cond: (student_id = student.id)
    * Planning Time: 3.252 ms
    * Execution Time: 161.433 ms
5. Script "Find student with marks by student's surname (partial match)" create index on exam_result.student_id and student.id:
    * Gather  (cost=1045.88..60975.48 rows=9000 width=17) (actual time=0.908..138.477 rows=445000 loops=1):
        * Workers Planned: 2
        * Workers Launched: 2
        * Nested Loop  (cost=45.88..59075.48 rows=3750 width=17) (actual time=0.195..48.538 rows=148333 loops=3):
            * Parallel Index Scan using student_pkey on student  (cost=0.29..3280.13 rows=4 width=21) (actual time=0.050..7.648 rows=148 loops=3):
                * Filter: ((surname)::text ~~ '%ock%'::text)
                * Rows Removed by Filter: 33185
                * Bitmap Heap Scan on exam_result  (cost=45.59..13911.24 rows=3760 width=12) (actual time=0.085..0.168 rows=1000 loops=445):
                    * Recheck Cond: (student_id = student.id)
                    * Heap Blocks: exact=1277
                    * Bitmap Index Scan on exam_result_student_id_index  (cost=0.00..44.65 rows=3760 width=0) (actual time=0.079..0.079 rows=1000 loops=445):
                        * Index Cond: (student_id = student.id)
    * Planning Time: 1.245 ms
    * Execution Time: 149.140 ms

## Using Gist index

1. Script "Find student by name (exact match)":
    * Bitmap Heap Scan on student  (cost=4.47..93.74 rows=25 width=66) (actual time=0.103..0.140 rows=38 loops=1):
        * Recheck Cond: ((name)::text = 'Sion'::text)
        * Heap Blocks: exact=38
        * Bitmap Index Scan on student_name_index  (cost=0.00..4.47 rows=25 width=0) (actual time=0.095..0.095 rows=38 loops=1):
            * Index Cond: ((name)::text = 'Sion'::text)
    * Planning Time: 0.079 ms
    * Execution Time: 0.174 ms
2. Script "Find student by surname (partial match)":
    * Seq Scan on student  (cost=0.00..2402.00 rows=9 width=66) (actual time=0.012..13.831 rows=445 loops=1):
        * Filter: ((surname)::text ~~ '%ock%'::text)
        * Rows Removed by Filter: 99555
    * Planning Time: 0.999 ms
    * Execution Time: 13.855 ms
3. Script "Find student by phone number (partial match)":
    * Seq Scan on student  (cost=0.00..2402.00 rows=10 width=66) (actual time=0.012..15.248 rows=7 loops=1):
        * Filter: (phone ~~ '%2401%'::text)
        * Rows Removed by Filter: 99993
    * Planning Time: 0.956 ms
    * Execution Time: 15.261 ms
4. Script "Find student with marks by student's surname (partial match)" create index on exam_result.student_id:
    * Gather  (cost=1125.86..61295.38 rows=9000 width=17) (actual time=0.935..159.315 rows=445000 loops=1):
        * Workers Planned: 2
        * Workers Launched: 2
    * Nested Loop  (cost=125.86..59395.38 rows=3750 width=17) (actual time=0.989..68.977 rows=148333 loops=3):
        * Parallel Index Scan using student_pkey on student  (cost=0.29..3280.13 rows=4 width=21) (actual time=0.545..11.515 rows=148 loops=3):
            * Filter: ((surname)::text ~~ '%ock%'::text)
            * Rows Removed by Filter: 33185
            * Bitmap Heap Scan on exam_result  (cost=125.56..13991.21 rows=3760 width=12) (actual time=0.147..0.259 rows=1000 loops=445):
                * Recheck Cond: (student_id = student.id)
                * Heap Blocks: exact=1288
                * Bitmap Index Scan on exam_result_student_id_index  (cost=0.00..124.62 rows=3760 width=0) (actual time=0.136..0.136 rows=1000 loops=445):
                    * Index Cond: (student_id = student.id)
    * Planning Time: 0.197 ms
    * Execution Time: 171.194 ms
5. Script "Find student with marks by student's surname (partial match)" create index on exam_result.student_id and student.id:
    * Gather  (cost=1125.86..61295.38 rows=9000 width=17) (actual time=0.852..149.391 rows=445000 loops=1):
        * Workers Planned: 2
        * Workers Launched: 2
        * Nested Loop  (cost=125.86..59395.38 rows=3750 width=17) (actual time=0.180..54.045 rows=148333 loops=3):
            * Parallel Index Scan using student_pkey on student  (cost=0.29..3280.13 rows=4 width=21) (actual time=0.039..8.407 rows=148 loops=3):
                * Filter: ((surname)::text ~~ '%ock%'::text)
                * Rows Removed by Filter: 33185
                * Bitmap Heap Scan on exam_result  (cost=125.56..13991.21 rows=3760 width=12) (actual time=0.106..0.193 rows=1000 loops=445):
                    * Recheck Cond: (student_id = student.id)
                    * Heap Blocks: exact=1296
                    * Bitmap Index Scan on exam_result_student_id_index  (cost=0.00..124.62 rows=3760 width=0) (actual time=0.100..0.100 rows=1000 loops=445):
                        * Index Cond: (student_id = student.id)
    * Planning Time: 1.384 ms
    * Execution Time: 161.019 ms